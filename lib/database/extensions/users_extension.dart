import 'package:chat_server/database/database.dart';
import 'package:chat_server/exceptions/api_exception.dart';
import 'package:drift/drift.dart';

extension UsersExtension on Database {
  Future<User?> getUserFromId({required int userId}) {
    final query = users.select()..where((tbl) => tbl.id.equals(userId));
    return query.getSingleOrNull();
  }

  Future<User?> getUserFromEmail({required String email}) {
    final query = users.select()..where((tbl) => tbl.email.equals(email));
    return query.getSingleOrNull();
  }

  Future<void> activateUser({required String activation}) {
    return transaction<void>(() async {
      final User? user = await (users.select()
            ..where((tbl) => tbl.activation.equals(activation)))
          .getSingleOrNull();

      if (user == null) {
        throw const ApiException.badRequest(
          'There is no user with such activation link',
        );
      }

      if (user.isActivated) {
        throw const ApiException.badRequest('Already activated');
      }

      final User newUser = user.copyWith(isActivated: true);

      final bool result = await users.update().replace(newUser);

      if (!result) {
        throw const ApiException.internalServerError(
          'Could not activate user',
        );
      }
    });
  }
}
