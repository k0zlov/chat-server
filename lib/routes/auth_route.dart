import 'package:chat_server/controllers/auth_controller/auth_controller.dart';
import 'package:chat_server/middleware/middleware_extension.dart';
import 'package:chat_server/middleware/validator_middleware.dart';
import 'package:chat_server/routes/server_route.dart';
import 'package:chat_server/utils/request_validator.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// A route handler for authentication-related endpoints.
class AuthRoute extends ServerRoute {
  /// Creates an instance of [AuthRoute] with the necessary middlewares and controller.
  AuthRoute({
    required this.authMiddleware,
    required this.controller,
    super.middlewares,
  });

  /// The controller that handles authentication logic.
  final AuthController controller;

  /// Middleware to handle authentication.
  final Middleware authMiddleware;

  @override
  String get name => 'auth';

  @override
  Router configureRouter(Router router) {
    // Validator parameters for the registration endpoint.
    const regParams = <ValidatorParameter<String>>[
      ValidatorParameter(name: 'name'),
      ValidatorParameter(name: 'email'),
      ValidatorParameter(name: 'password'),
    ];

    // Middleware to validate registration request body.
    final Middleware regValidator = validatorMiddleware(bodyParams: regParams);

    // Validator parameters for the login endpoint.
    const loginParams = <ValidatorParameter<String>>[
      ValidatorParameter(name: 'email'),
      ValidatorParameter(name: 'password'),
    ];

    // Middleware to validate login request body.
    final Middleware loginValidator =
        validatorMiddleware(bodyParams: loginParams);

    return router
      // Route to get user details, protected by authentication middleware.
      ..getMw('/', controller.getUser, [authMiddleware])
      // Route to refresh the access token.
      ..get('/refresh', controller.refresh)
      // Route to activate user account.
      ..get('/activation/<activation>', controller.activation)
      // Route to logout, protected by authentication middleware.
      ..postMw('/logout', controller.logout, [authMiddleware])
      // Route to login, protected by login validation middleware.
      ..postMw('/login', controller.login, [loginValidator])
      // Route to register, protected by registration validation middleware.
      ..postMw('/register', controller.register, [regValidator]);
  }
}
