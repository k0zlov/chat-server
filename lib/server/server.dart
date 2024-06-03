import 'dart:io';

import 'package:chat_server/middleware/middleware_handler.dart';
import 'package:chat_server/routes/server_route.dart';
import 'package:chat_server/server/server_config.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

class ChatServer {
  ChatServer({
    required this.config,
    this.middlewares = const <MiddlewareHandler>[],
    this.routes = const <ServerRoute>[],
  }) {
    _buildRoutes();
  }

  final Router _router = Router();

  final ServerConfig config;

  final List<ServerRoute> routes;

  final List<MiddlewareHandler> middlewares;

  void _buildRoutes() {
    _router.get('/', (req) => Response.ok('Hello world!'));

    for (final ServerRoute route in routes) {
      _router.mount('/${route.name}', route.build());
    }
  }

  Future<void> run() async {
    Pipeline pipeline = const Pipeline();

    for (final MiddlewareHandler middleware in middlewares) {
      pipeline = pipeline.addMiddleware(middleware());
    }

    final Handler handler = pipeline.addHandler(_router.call);

    final HttpServer server = await serve(
      handler,
      config.ip,
      config.port,
    );

    print('Server listening on port ${server.port}');
  }
}
