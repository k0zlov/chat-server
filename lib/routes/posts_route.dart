import 'package:chat_server/controllers/posts_controller.dart';
import 'package:chat_server/routes/server_route.dart';
import 'package:shelf_router/shelf_router.dart';

class PostsRoute extends ServerRoute {
  PostsRoute({
    required this.postsController,
    super.middlewares,
  });

  final PostsController postsController;

  @override
  String get name => 'posts';

  @override
  Router configureRouter(Router router) {
    return router
      ..get('/', postsController.root)
      ..post('/add', postsController.addPost)
      ..delete('/remove', postsController.removePost);
  }
}
