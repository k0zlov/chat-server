part of 'register_dependencies.dart';

void _routes() {
  final Middleware authMiddleware = getIt(instanceName: 'auth-middleware');

  getIt
    ..registerLazySingleton<ServerRoute>(
      instanceName: 'posts-route',
      () => PostsRoute(
        controller: getIt(),
        authMiddleware: authMiddleware,
      ),
    )
    ..registerLazySingleton<ServerRoute>(
      instanceName: 'auth-route',
      () => AuthRoute(
        controller: getIt(),
        authMiddleware: authMiddleware,
      ),
    )
    ..registerLazySingleton<ServerRoute>(
      instanceName: 'contacts-route',
      () => ContactsRoute(
        controller: getIt(),
        middlewares: [authMiddleware],
      ),
    )
    ..registerLazySingleton<ServerRoute>(
      instanceName: 'chats-route',
      () => ChatsRoute(
        controller: getIt(),
        middlewares: [authMiddleware],
      ),
    )
    ..registerLazySingleton<ServerRoute>(
      instanceName: 'messages-route',
      () => MessagesRoute(
        controller: getIt(),
        middlewares: [authMiddleware],
      ),
    );
}
