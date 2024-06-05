import 'dart:async';
import 'dart:io';

import 'package:chat_server/exceptions/api_exception.dart';
import 'package:chat_server/routes/server_route.dart';
import 'package:chat_server/server/server_config.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

class ChatServer {
  ChatServer({
    required this.config,
    this.middlewares = const <Middleware>[],
    this.routes = const <ServerRoute>[],
  }) {
    _router = Router(notFoundHandler: _notFoundHandler);
    _buildRoutes();
  }

  late final Router _router;

  final ServerConfig config;

  final List<ServerRoute> routes;

  final List<Middleware> middlewares;

  Response _notFoundHandler(Request request) {
    return const ApiException.notFound().toResponse();
  }

  void _buildRoutes() {
    _router.get('/', (req) => Response.ok('Hello world!'));

    for (final ServerRoute route in routes) {
      _router.mount('/${route.name}', route.build());
    }
  }

  Future<void> run() async {
    Pipeline pipeline = const Pipeline();

    for (final Middleware middleware in middlewares) {
      pipeline = pipeline.addMiddleware(middleware);
    }

    final Handler handler = pipeline.addHandler(_router.call);

    final HttpServer server = await serve(
      handler,
      config.ip,
      config.port,
    );

    server.autoCompress = true;

    print('Server listening on ${server.address.host}:${server.port}');
  }
}
