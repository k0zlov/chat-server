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
    )
    ..registerLazySingleton<ContactsController>(
      () => ContactsControllerImpl(database: getIt()),
    )
    ..registerLazySingleton<ChatsController>(
      () => ChatsControllerImpl(database: getIt()),
    )
    ..registerLazySingleton<MessagesController>(
      () => MessagesControllerImpl(database: getIt()),
    );
}
