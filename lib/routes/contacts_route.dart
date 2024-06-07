import 'package:chat_server/controllers/contacts_controller/contacts_controller.dart';
import 'package:chat_server/middleware/middleware_extension.dart';
import 'package:chat_server/middleware/validator_middleware.dart';
import 'package:chat_server/routes/server_route.dart';
import 'package:chat_server/utils/request_validator.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// A route handler for contacts-related endpoints.
class ContactsRoute extends ServerRoute {
  /// Creates an instance of [ContactsRoute] with the necessary controller and middlewares.
  ContactsRoute({
    required this.controller,
    super.middlewares,
  });

  /// The controller that handles contacts logic.
  final ContactsController controller;

  @override
  String get name => 'contacts';

  @override
  Router configureRouter(Router router) {
    // Validator parameters for the add and remove endpoints.
    const params = <ValidatorParameter<String>>[
      ValidatorParameter(name: 'contactUserEmail'),
    ];

    // Middleware to validate add and remove request body.
    final Middleware validator = validatorMiddleware(bodyParams: params);

    // Validator parameters for the search endpoint.
    const searchParams = <String>[
      'username',
    ];

    // Middleware to validate search request parameters.
    final Middleware searchValidator = validatorMiddleware(
      requestParams: searchParams,
    );

    return router
      // Route to get all contacts.
      ..get('/', controller.getAll)
      // Route to add a contact, protected by validation middleware.
      ..postMw('/add', controller.add, [validator])
      // Route to remove a contact, protected by validation middleware.
      ..deleteMw('/remove', controller.remove, [validator])
      // Route to search for contacts, protected by search validation middleware.
      ..getMw('/search', controller.search, [searchValidator]);
  }
}
