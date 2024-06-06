import 'package:chat_server/controllers/messages_controller/messages_controller.dart';
import 'package:chat_server/middleware/middleware_extension.dart';
import 'package:chat_server/middleware/validator_middleware.dart';
import 'package:chat_server/routes/server_route.dart';
import 'package:chat_server/utils/request_validator.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class MessagesRoute extends ServerRoute {
  MessagesRoute({
    required this.controller,
    super.middlewares,
  });

  final MessagesController controller;

  @override
  String get name => 'messages';

  @override
  Router configureRouter(Router router) {
    const sendParams = <ValidatorParameter<Object>>[
      ValidatorParameter<int>(name: 'chatId'),
      ValidatorParameter<String>(name: 'content'),
    ];

    final Middleware sendValidator = validatorMiddleware(
      bodyParams: sendParams,
    );

    const deleteParams = <String>['messageId'];

    final Middleware deleteValidator = validatorMiddleware(
      requestParams: deleteParams,
    );

    const updateParams = <ValidatorParameter<Object>>[
      ValidatorParameter<int>(name: 'messageId'),
      ValidatorParameter<String>(name: 'content'),
    ];

    final Middleware updateValidator = validatorMiddleware(
      bodyParams: updateParams,
    );

    return router
      ..postMw('/send', controller.send, [sendValidator])
      ..deleteMw('/delete', controller.delete, [deleteValidator])
      ..putMw('/update', controller.update, [updateValidator]);
  }
}
