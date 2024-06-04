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
    expiresIn: const Duration(minutes: 30),
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

  final String baseUrl = _env.getOrElse('BASE_URL', _orElse);
  final String emailAddress = _env.getOrElse('EMAIL_ADDRESS', _orElse);

  final String region = _env.getOrElse('AWS_REGION', _orElse);
  final String awsAccessKey = _env.getOrElse('AWS_ACCESS_KEY', _orElse);
  final String awsSecretKey = _env.getOrElse('AWS_SECRET_KEY', _orElse);

  final SESV2 sesClient = SESV2(
    region: region,
    credentials: AwsClientCredentials(
      accessKey: awsAccessKey,
      secretKey: awsSecretKey,
    ),
  );

  getIt.registerLazySingleton<MailService>(
    () => MailServiceImpl(
      emailAddress: emailAddress,
      sesClient: sesClient,
      baseUrl: baseUrl,
    ),
  );
}
