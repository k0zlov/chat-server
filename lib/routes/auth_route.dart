import 'package:chat_server/controllers/auth_controller.dart';
import 'package:chat_server/routes/server_route.dart';
import 'package:shelf_router/shelf_router.dart';

class AuthRoute extends ServerRoute {
  AuthRoute({
    required this.authController,
    super.middlewares,
  });

  final AuthController authController;

  @override
  String get name => 'auth';

  @override
  Router configureRouter(Router router) {
    return router
      ..get('/', authController.root)
      ..get('/refresh', authController.refresh)
      ..post('/activation', authController.activation)
      ..post('/login', authController.login)
      ..post('/register', authController.register);
  }
}
