import 'dart:io';

import 'package:chat_server/controllers/posts_controller.dart';
import 'package:chat_server/database/database.dart';
import 'package:chat_server/middleware/error_middleware.dart';
import 'package:chat_server/middleware/logging_middleware.dart';
import 'package:chat_server/middleware/middleware_handler.dart';
import 'package:chat_server/routes/posts_route.dart';
import 'package:chat_server/routes/server_route.dart';
import 'package:chat_server/server/server.dart';
import 'package:chat_server/server/server_config.dart';
import 'package:dotenv/dotenv.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:get_it/get_it.dart';
import 'package:postgres/postgres.dart';

/// GetIt instance
final GetIt getIt = GetIt.instance;

Future<ChatServer> registerDependencies() async {
  await _database();

  _controllers();
  _routes();
  _middlewares();
  return _server();
}

void _controllers() {
  getIt.registerLazySingleton<PostsController>(
    () => PostsControllerImpl(database: getIt()),
  );
}

void _routes() {
  getIt.registerLazySingleton<ServerRoute>(
    instanceName: 'posts-route',
    () => PostsRoute(postsController: getIt()),
  );
}

void _middlewares() {
  getIt
    ..registerLazySingleton<MiddlewareHandler>(
      instanceName: 'error-middleware',
      ErrorMiddleware.new,
    )
    ..registerLazySingleton<MiddlewareHandler>(
      instanceName: 'logging-middleware',
      LoggingMiddleware.new,
    );
}

Future<void> _database() async {
  final DotEnv env = DotEnv(includePlatformEnvironment: true)..load(['../../.env']);

  String orElse() => '';

  final int? port = int.tryParse(env.getOrElse('DATABASE_PORT', orElse));
  final String host = env.getOrElse('DATABASE_HOST', orElse);
  final String name = env.getOrElse('DATABASE_NAME', orElse);
  final String password = env.getOrElse('DATABASE_PASSWORD', orElse);
  final String username = env.getOrElse('DATABASE_USERNAME', orElse);

  final Endpoint endpoint = Endpoint(
    host: host,
    port: port ?? 5432,
    database: name,
    password: password,
    username: username,
  );

  final Database database = Database(
    PgDatabase(
      endpoint: endpoint,
      settings: const ConnectionSettings(
        // If you expect to talk to a Postgres database over a public connection,
        // please use SslMode.verifyFull instead.
        sslMode: SslMode.disable,
      ),
      logStatements: true,
    ),
  );

  try {
    await database.posts.all().get();
    print('Connected to database.');
  } catch (e) {
    print('Could not connect to database.');
  }

  getIt.registerSingleton<Database>(database);
}

ChatServer _server() {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final ChatServer server = ChatServer(
    routes: <ServerRoute>[
      getIt(instanceName: 'posts-route'),
    ],
    middlewares: <MiddlewareHandler>[
      getIt(instanceName: 'error-middleware'),
      getIt(instanceName: 'logging-middleware'),
    ],
    config: ServerConfig(
      ip: ip,
      port: port,
    ),
  );

  return server;
}
