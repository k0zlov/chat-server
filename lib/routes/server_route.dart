import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

abstract class ServerRoute {
  ServerRoute({required this.middlewares}) {
    router = configureRouter(Router());
  }

  final List<Middleware>? middlewares;

  late final Router router;

  String get name;

  Router configureRouter(Router router);

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

