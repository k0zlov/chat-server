import 'package:chat_server/controllers/messages_controller/messages_controller.dart';
import 'package:chat_server/middleware/middleware_extension.dart';
import 'package:chat_server/middleware/validator_middleware.dart';
import 'package:chat_server/routes/server_route.dart';
import 'package:chat_server/utils/request_validator.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// A route handler for messages-related endpoints.
class MessagesRoute extends ServerRoute {
  /// Creates an instance of [MessagesRoute] with the necessary controller and middlewares.
  MessagesRoute({
    required this.controller,
    super.middlewares,
  });

  /// The controller that handles messages logic.
  final MessagesController controller;

  @override
  String get name => 'messages';

  @override
  Router configureRouter(Router router) {
    // Validator parameters for the send endpoint.
    const sendParams = <ValidatorParameter<Object>>[
      ValidatorParameter<int>(name: 'chatId'),
      ValidatorParameter<String>(name: 'content'),
    ];

    // Middleware to validate send request body.
    final Middleware sendValidator = validatorMiddleware(
      bodyParams: sendParams,
    );

    // Validator parameters for the delete endpoint.
    const deleteParams = <String>['messageId'];

    // Middleware to validate delete request parameters.
    final Middleware deleteValidator = validatorMiddleware(
      requestParams: deleteParams,
    );

    // Validator parameters for the update endpoint.
    const updateParams = <ValidatorParameter<Object>>[
      ValidatorParameter<int>(name: 'messageId'),
      ValidatorParameter<String>(name: 'content'),
    ];

    // Middleware to validate update request body.
    final Middleware updateValidator = validatorMiddleware(
      bodyParams: updateParams,
    );

    return router
    // Route to send a message, protected by send validation middleware.
      ..postMw('/send', controller.send, [sendValidator])
    // Route to delete a message, protected by delete validation middleware.
      ..deleteMw('/delete', controller.delete, [deleteValidator])
    // Route to update a message, protected by update validation middleware.
      ..putMw('/update', controller.update, [updateValidator]);
  }
}
