import 'dart:io';

import 'package:chat_server/controllers/auth_controller.dart';
import 'package:chat_server/controllers/posts_controller.dart';
import 'package:chat_server/database/database.dart';
import 'package:chat_server/middleware/auth_middleware.dart';
import 'package:chat_server/middleware/error_middleware.dart';
import 'package:chat_server/middleware/headers_middleware.dart';
import 'package:chat_server/routes/auth_route.dart';
import 'package:chat_server/routes/posts_route.dart';
import 'package:chat_server/routes/server_route.dart';
import 'package:chat_server/server/server.dart';
import 'package:chat_server/server/server_config.dart';
import 'package:chat_server/services/token_service.dart';
import 'package:chat_server/utils/jwt_client.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:get_it/get_it.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';

/// GetIt instance
final GetIt getIt = GetIt.instance;

final DotEnv _env = DotEnv(includePlatformEnvironment: true)
  ..load(['../../.env']);

String _orElse() => '';

Future<ChatServer> registerDependencies() async {
  await _database();

  _services();
  _controllers();
  _routes();
  return _server();
}

void _controllers() {
  getIt
    ..registerLazySingleton<PostsController>(
      () => PostsControllerImpl(database: getIt()),
    )
    ..registerLazySingleton<AuthController>(
      () => AuthControllerImpl(
        database: getIt(),
        tokenService: getIt(),
      ),
    );
}

void _routes() {
  getIt
    ..registerLazySingleton<ServerRoute>(
      instanceName: 'posts-route',
      () => PostsRoute(
        postsController: getIt(),
        middlewares: [authMiddleware(tokenService: getIt())],
      ),
    )
    ..registerLazySingleton<ServerRoute>(
      instanceName: 'auth-route',
      () => AuthRoute(authController: getIt()),
    );
}

void _services() {
  final String accessSecret = _env.getOrElse(
    'JWT_ACCESS_SECRET',
    _orElse,
  );
  final String refreshSecret = _env.getOrElse(
    'JWT_REFRESH_SECRET',
    _orElse,
  );

  final JwtClient accessClient = JwtClient(
    secretKey: SecretKey(accessSecret),
    expiresIn: const Duration(minutes: 1),
  );

  final JwtClient refreshClient = JwtClient(
    secretKey: SecretKey(refreshSecret),
    expiresIn: const Duration(days: 7),
  );

  getIt.registerLazySingleton<TokenService>(
    () => TokenServiceImpl(
      refreshClient: refreshClient,
      accessClient: accessClient,
    ),
  );
}

Future<void> _database() async {
  final int? port = int.tryParse(_env.getOrElse('DATABASE_PORT', _orElse));
  final String host = _env.getOrElse('DATABASE_HOST', _orElse);
  final String name = _env.getOrElse('DATABASE_NAME', _orElse);
  final String password = _env.getOrElse('DATABASE_PASSWORD', _orElse);
  final String username = _env.getOrElse('DATABASE_USERNAME', _orElse);

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

  final headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  final ChatServer server = ChatServer(
    routes: <ServerRoute>[
      getIt(instanceName: 'posts-route'),
      getIt(instanceName: 'auth-route'),
    ],
    middlewares: <Middleware>[
      logRequests(),
      headersMiddleware(headers),
      errorMiddleware(),
    ],
    config: ServerConfig(
      ip: ip,
      port: port,
    ),
  );

  return server;
}
