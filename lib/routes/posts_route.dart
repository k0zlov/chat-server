import 'package:chat_server/controllers/posts_controller.dart';
import 'package:chat_server/middleware/middleware_extension.dart';
import 'package:chat_server/middleware/validator_middleware.dart';
import 'package:chat_server/routes/server_route.dart';
import 'package:chat_server/utils/request_validator.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class PostsRoute extends ServerRoute {
  PostsRoute({
    required this.authMiddleware,
    required this.controller,
    super.middlewares,
  });

  final PostsController controller;
  final Middleware authMiddleware;

  @override
  String get name => 'posts';

  @override
  Router configureRouter(Router router) {
    const addParams = <ValidatorParameter<Object>>[
      ValidatorParameter(name: 'subject'),
      ValidatorParameter(name: 'content', nullable: true),
    ];

    final Middleware addValidator = validatorMiddleware(
      bodyParams: addParams,
    );

    const removeParams = <String>['id'];

    final Middleware removeValidator = validatorMiddleware(
      requestParams: removeParams,
    );

    return router
      ..get('/', controller.getPosts)
      ..postMw('/add', controller.addPost, [authMiddleware, addValidator])
      ..deleteMw(
        '/remove',
        controller.removePost,
        [authMiddleware, removeValidator],
      );
  }
}
