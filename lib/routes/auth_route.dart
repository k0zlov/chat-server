import 'package:chat_server/controllers/auth_controller.dart';
import 'package:chat_server/middleware/middleware_extension.dart';
import 'package:chat_server/middleware/validator_middleware.dart';
import 'package:chat_server/routes/server_route.dart';
import 'package:chat_server/utils/request_validator.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class AuthRoute extends ServerRoute {
  AuthRoute({
    required this.authMiddleware,
    required this.controller,
    super.middlewares,
  });

  final AuthController controller;
  final Middleware authMiddleware;

  @override
  String get name => 'auth';

  @override
  Router configureRouter(Router router) {
    const regParams = <ValidatorParameter<String>>[
      ValidatorParameter(name: 'name'),
      ValidatorParameter(name: 'email'),
      ValidatorParameter(name: 'password'),
    ];

    final Middleware regValidator = validatorMiddleware(bodyParams: regParams);

    const loginParams = <ValidatorParameter<String>>[
      ValidatorParameter(name: 'email'),
      ValidatorParameter(name: 'password'),
    ];

    final Middleware loginValidator =
        validatorMiddleware(bodyParams: loginParams);

    return router
      ..getMw('/', controller.getUser, [authMiddleware])
      ..get('/refresh', controller.refresh)
      ..get('/activation/<activation>', controller.activation)
      ..postMw('/login', controller.login, [loginValidator])
      ..postMw('/register', controller.register, [regValidator]);
  }
}
