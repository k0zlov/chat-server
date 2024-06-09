part of 'register_dependencies.dart';

void _middleware() {
  final headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  getIt
    ..registerLazySingleton<Middleware>(
      instanceName: 'auth-middleware',
      () => authMiddleware(
        tokenService: getIt(),
        database: getIt(),
      ),
    )
    ..registerLazySingleton<Middleware>(
      instanceName: 'headers-middleware',
      () => headersMiddleware(headers),
    );
}
