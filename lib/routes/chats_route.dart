import 'package:chat_server/controllers/chats_controller/chats_controller.dart';
import 'package:chat_server/middleware/middleware_extension.dart';
import 'package:chat_server/middleware/validator_middleware.dart';
import 'package:chat_server/routes/server_route.dart';
import 'package:chat_server/utils/request_validator.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ChatsRoute extends ServerRoute {
  ChatsRoute({
    required this.controller,
    super.middlewares,
  });

  final ChatsController controller;

  @override
  String get name => 'chats';

  @override
  Router configureRouter(Router router) {
    /// Create
    const createParams = <ValidatorParameter<String>>[
      ValidatorParameter(name: 'title'),
      ValidatorParameter(name: 'description', nullable: true),
      ValidatorParameter(name: 'chatType', nullable: true),
    ];

    final Middleware createValidator = validatorMiddleware(
      bodyParams: createParams,
    );

    /// Delete
    const deleteParams = <String>['chatId'];

    final Middleware deleteValidator = validatorMiddleware(
      requestParams: deleteParams,
    );

    /// Update
    const updateParams = <ValidatorParameter<Object>>[
      ValidatorParameter<int>(name: 'chatId'),
      ValidatorParameter<String>(name: 'title', nullable: true),
      ValidatorParameter<String>(name: 'description', nullable: true),
      ValidatorParameter<String>(name: 'chatType', nullable: true),
    ];

    final Middleware updateValidator = validatorMiddleware(
      bodyParams: updateParams,
    );

    /// Search
    const searchParams = <String>['title'];

    final Middleware searchValidator = validatorMiddleware(
      requestParams: searchParams,
    );

    /// Join & Leave
    const params = <ValidatorParameter<int>>[
      ValidatorParameter(name: 'chatId'),
    ];

    final Middleware validator = validatorMiddleware(
      bodyParams: params,
    );

    return router
      ..get('/', controller.getAll)
      ..postMw('/create', controller.create, [createValidator])
      ..deleteMw('/delete', controller.delete, [deleteValidator])
      ..putMw('/update', controller.update, [updateValidator])
      ..postMw('/join', controller.join, [validator])
      ..postMw('/leave', controller.leave, [validator])
      ..getMw('/search', controller.search, [searchValidator]);
  }
}
