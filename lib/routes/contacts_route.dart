import 'package:chat_server/controllers/contacts_controller/contacts_controller.dart';
import 'package:chat_server/middleware/middleware_extension.dart';
import 'package:chat_server/middleware/validator_middleware.dart';
import 'package:chat_server/routes/server_route.dart';
import 'package:chat_server/utils/request_validator.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ContactsRoute extends ServerRoute {
  ContactsRoute({
    required this.controller,
    super.middlewares,
  });

  final ContactsController controller;

  @override
  String get name => 'contacts';

  @override
  Router configureRouter(Router router) {
    const params = <ValidatorParameter<int>>[
      ValidatorParameter(name: 'contactUserId'),
    ];

    // Validator for add and remove endpoints
    final Middleware validator = validatorMiddleware(bodyParams: params);

    const searchParams = <String>[
      'username',
    ];

    final Middleware searchValidator = validatorMiddleware(
      requestParams: searchParams,
    );

    return router
      ..get('/', controller.getAll)
      ..postMw('/add', controller.add, [validator])
      ..deleteMw('/remove', controller.remove, [validator])
      ..getMw('/search', controller.search, [searchValidator]);
  }
}
