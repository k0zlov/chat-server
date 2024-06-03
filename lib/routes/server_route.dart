import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

abstract class ServerRoute {
  ServerRoute({required this.middleware}) {
    router = configureRouter(Router());
  }

  final Middleware? middleware;

  late final Router router;

  String get name;

  Router configureRouter(Router router);

  Handler build() {
    if (middleware == null) {
      return router.call;
    } else {
      final handler =
          const Pipeline().addMiddleware(middleware!).addHandler(router.call);

      return handler;
    }
  }
}
