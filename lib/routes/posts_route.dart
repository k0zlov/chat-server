import 'package:chat_server/controllers/posts_controller/posts_controller.dart';
import 'package:chat_server/middleware/middleware_extension.dart';
import 'package:chat_server/middleware/validator_middleware.dart';
import 'package:chat_server/routes/server_route.dart';
import 'package:chat_server/utils/request_validator.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// A route handler for posts-related endpoints.
class PostsRoute extends ServerRoute {
  /// Creates an instance of [PostsRoute] with the necessary controller and middlewares.
  PostsRoute({
    required this.authMiddleware,
    required this.controller,
    super.middlewares,
  });

  /// The controller that handles posts logic.
  final PostsController controller;

  /// Middleware to handle authentication.
  final Middleware authMiddleware;

  @override
  String get name => 'posts';

  @override
  Router configureRouter(Router router) {
    // Validator parameters for the add post endpoint.
    const addParams = <ValidatorParameter<Object>>[
      ValidatorParameter(name: 'subject'),
      ValidatorParameter(name: 'content', nullable: true),
    ];

    // Middleware to validate add post request body.
    final Middleware addValidator = validatorMiddleware(
      bodyParams: addParams,
    );

    // Validator parameters for the remove post endpoint.
    const removeParams = <String>['id'];

    // Middleware to validate remove post request parameters.
    final Middleware removeValidator = validatorMiddleware(
      requestParams: removeParams,
    );

    return router
      // Route to get all posts.
      ..get('/', controller.getAll)
      // Route to add a post, protected by authentication and add validation middleware.
      ..postMw('/add', controller.addPost, [authMiddleware, addValidator])
      // Route to remove a post, protected by authentication and remove validation middleware.
      ..deleteMw(
        '/remove',
        controller.removePost,
        [authMiddleware, removeValidator],
      );
  }
}
