import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

extension MiddlwareExtensions on Router {
  void addMw(
    String method,
    String route, {
    required Handler handler,
    required List<Middleware> middlewares,
  }) {
    Pipeline pipeline = const Pipeline();

    for (final middleware in middlewares) {
      pipeline = pipeline.addMiddleware(middleware);
    }

    final handlerWithMiddleware = pipeline.addHandler(handler);
    add(method, route, handlerWithMiddleware);
  }

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
}
