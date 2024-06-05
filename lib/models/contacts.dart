import 'package:chat_server/models/users.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

class Contacts extends Table {
  @ReferenceName('contactOwners')
  IntColumn get userId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();

  @ReferenceName('contactTargets')
  IntColumn get contactUserId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();

  TimestampColumn get addedAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(
        const FunctionCallExpression('now', []),
      )();

  @override
  Set<Column> get primaryKey => {userId, contactUserId};

  @override
  List<String> get customConstraints => [
        'CHECK (user_id <> contact_user_id)',
      ];
}
