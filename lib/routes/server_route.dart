import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// Abstract class representing a server route with optional middlewares.
abstract class ServerRoute {
  /// Creates an instance of [ServerRoute] and configures the router.
  ServerRoute({required this.middlewares}) {
    router = configureRouter(Router());
  }

  /// List of middlewares to be applied to the route.
  final List<Middleware>? middlewares;

  /// The router instance for this route.
  late final Router router;

  /// The name of the route, to be implemented by subclasses.
  String get name;

  /// Configures the router with the necessary routes and handlers.
  /// Must be implemented by subclasses.
  Router configureRouter(Router router);

  /// Builds the handler for this route, applying middlewares if any are provided.
  Handler build() {
    if (middlewares == null || middlewares!.isEmpty) return router.call;

    Pipeline pipeline = const Pipeline();

    for (final Middleware middleware in middlewares!) {
      pipeline = pipeline.addMiddleware(middleware);
    }

    final Handler handler = pipeline.addHandler(router.call);
    return handler;
  }
}
