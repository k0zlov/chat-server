import 'dart:async';
import 'dart:io';

import 'package:chat_server/exceptions/api_exception.dart';
import 'package:chat_server/routes/server_route.dart';
import 'package:chat_server/server/server_config.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

/// A class representing the chat server.
class ChatServer {
  /// Creates an instance of [ChatServer] with the specified configuration, middlewares, and routes.
  ChatServer({
    required this.config,
    this.middlewares = const <Middleware>[],
    this.routes = const <ServerRoute>[],
  }) {
    _router = Router(notFoundHandler: _notFoundHandler);
    _buildRoutes();
  }

  /// The router instance used for defining routes.
  late final Router _router;

  /// The configuration for the server.
  final ServerConfig config;

  /// The list of routes to be added to the server.
  final List<ServerRoute> routes;

  /// The list of middlewares to be applied to the server.
  final List<Middleware> middlewares;

  /// Handler for requests that do not match any route.
  Response _notFoundHandler(Request request) {
    return const ApiException.notFound().toResponse();
  }

  /// Builds the routes for the server.
  void _buildRoutes() {
    _router.get('/', (req) => Response.ok('Hello world!'));

    for (final ServerRoute route in routes) {
      _router.mount('/${route.name}', route.build());
    }
  }

  /// Runs the server with the configured middlewares and routes.
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
