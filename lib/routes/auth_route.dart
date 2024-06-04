import 'package:chat_server/controllers/auth_controller.dart';
import 'package:chat_server/routes/server_route.dart';
import 'package:shelf_router/shelf_router.dart';

class AuthRoute extends ServerRoute {
  AuthRoute({
    required this.controller,
    super.middlewares,
  });

  final AuthController controller;

  @override
  String get name => 'auth';

  @override
  Router configureRouter(Router router) {
    return router
      ..get('/', controller.root)
      ..get('/refresh', controller.refresh)
      ..post('/activation', controller.activation)
      ..post('/login', controller.login)
      ..post('/register', controller.register);
  }
}
