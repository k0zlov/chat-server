import 'package:chat_server/controllers/posts_controller.dart';
import 'package:chat_server/middleware/middleware_extension.dart';
import 'package:chat_server/routes/server_route.dart';
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
    return router
      ..get('/', controller.root)
      ..postMw('/add', controller.addPost, [authMiddleware])
      ..deleteMw('/remove', controller.removePost, [authMiddleware]);
  }
}
