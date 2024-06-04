part of 'register_dependencies.dart';

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
