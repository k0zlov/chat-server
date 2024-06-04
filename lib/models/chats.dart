import 'package:chat_server/models/users.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

enum ChatType {
  private,
  group,
  channel,
}

class Chats extends Table {
  IntColumn get id => integer().autoIncrement()();

  @ReferenceName('chatOwners')
  IntColumn get ownerId => integer().references(Users, #id)();

  TextColumn get type => textEnum<ChatType>()();

  TimestampColumn get createdAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(
        const FunctionCallExpression('now', []),
      )();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
