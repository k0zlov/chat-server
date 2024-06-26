import 'dart:io';

import 'package:aws_sesv2_api/sesv2-2019-09-27.dart';
import 'package:chat_server/controllers/auth_controller/auth_controller.dart';
import 'package:chat_server/controllers/auth_controller/auth_controller_impl.dart';
import 'package:chat_server/controllers/chats_controller/chats_controller.dart';
import 'package:chat_server/controllers/chats_controller/chats_controller_impl.dart';
import 'package:chat_server/controllers/contacts_controller/contacts_controller.dart';
import 'package:chat_server/controllers/contacts_controller/contacts_controller_impl.dart';
import 'package:chat_server/controllers/messages_controller/messages_controller.dart';
import 'package:chat_server/controllers/messages_controller/messages_controller_impl.dart';
import 'package:chat_server/controllers/posts_controller/posts_controller.dart';
import 'package:chat_server/controllers/posts_controller/posts_controller_impl.dart';
import 'package:chat_server/database/database.dart';
import 'package:chat_server/middleware/auth_middleware.dart';
import 'package:chat_server/middleware/error_middleware.dart';
import 'package:chat_server/middleware/headers_middleware.dart';
import 'package:chat_server/routes/auth_route.dart';
import 'package:chat_server/routes/chats_route.dart';
import 'package:chat_server/routes/contacts_route.dart';
import 'package:chat_server/routes/messages_route.dart';
import 'package:chat_server/routes/posts_route.dart';
import 'package:chat_server/routes/server_route.dart';
import 'package:chat_server/server/server.dart';
import 'package:chat_server/server/server_config.dart';
import 'package:chat_server/services/mail_service.dart';
import 'package:chat_server/services/token_service.dart';
import 'package:chat_server/utils/jwt_client.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:get_it/get_it.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';

part 'services.dart';

part 'database.dart';

part 'controllers.dart';

part 'middleware.dart';

part 'routes.dart';

/// GetIt instance
final GetIt getIt = GetIt.instance;

/// Loading environment variables
final DotEnv _env = DotEnv(includePlatformEnvironment: true)
  ..load(['../../.env']);

String _orElse() => '';

Future<ChatServer> registerDependencies() async {
  await _database();

  _services();
  _controllers();
  _middleware();
  _routes();

  return _server();
}

ChatServer _server() {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final ChatServer server = ChatServer(
    routes: <ServerRoute>[
      getIt(instanceName: 'posts-route'),
      getIt(instanceName: 'auth-route'),
      getIt(instanceName: 'contacts-route'),
      getIt(instanceName: 'chats-route'),
      getIt(instanceName: 'messages-route'),
    ],
    middlewares: <Middleware>[
      getIt(instanceName: 'headers-middleware'),
      logRequests(),
      errorMiddleware(),
    ],
    config: ServerConfig(
      ip: ip,
      port: port,
    ),
  );

  return server;
}
