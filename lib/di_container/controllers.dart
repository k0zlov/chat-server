part of 'register_dependencies.dart';

void _controllers() {
  getIt
    ..registerLazySingleton<PostsController>(
      () => PostsControllerImpl(database: getIt()),
    )
    ..registerLazySingleton<AuthController>(
      () => AuthControllerImpl(
        database: getIt(),
        tokenService: getIt(),
        mailService: getIt(),
      ),
    );
}
