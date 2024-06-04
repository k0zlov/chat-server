part of 'register_dependencies.dart';

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
