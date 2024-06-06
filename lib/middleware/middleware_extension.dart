import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// Extension on [Router] to add routes with middlewares.
extension MiddlewareExtensions on Router {
  /// Adds a route with the specified [method] and [route] to the router,
  /// applying the provided [middlewares] to the [handler].
  void addMw(
    String method,
    String route, {
    required Handler handler,
    required List<Middleware> middlewares,
  }) {
    // Create a pipeline and add each middleware to it.
    Pipeline pipeline = const Pipeline();
    for (final middleware in middlewares) {
      pipeline = pipeline.addMiddleware(middleware);
    }

    // Wrap the handler with the middlewares.
    final handlerWithMiddleware = pipeline.addHandler(handler);

    // Add the route to the router.
    add(method, route, handlerWithMiddleware);
  }

  /// Adds a GET route with middlewares.
  void getMw(
    String route,
    Handler handler,
    List<Middleware> middlewares,
  ) {
    addMw(
      'GET',
      route,
      handler: handler,
      middlewares: middlewares,
    );
  }

  /// Adds a DELETE route with middlewares.
  void deleteMw(
    String route,
    Handler handler,
    List<Middleware> middlewares,
  ) {
    addMw(
      'DELETE',
      route,
      handler: handler,
      middlewares: middlewares,
    );
  }

  /// Adds a POST route with middlewares.
  void postMw(
    String route,
    Handler handler,
    List<Middleware> middlewares,
  ) {
    addMw(
      'POST',
      route,
      handler: handler,
      middlewares: middlewares,
    );
  }

  /// Adds a PUT route with middlewares.
  void putMw(
    String route,
    Handler handler,
    List<Middleware> middlewares,
  ) {
    addMw(
      'PUT',
      route,
      handler: handler,
      middlewares: middlewares,
    );
  }
}
