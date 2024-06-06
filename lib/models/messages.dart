import 'package:chat_server/database/database.dart';
import 'package:chat_server/models/chats.dart';
import 'package:chat_server/models/users.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

class Messages extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get content => text().withLength(min: 1)();

  @ReferenceName('messageAuthors')
  IntColumn get userId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();

  @ReferenceName('messageChats')
  IntColumn get chatId =>
      integer().references(Chats, #id, onDelete: KeyAction.cascade)();

  TimestampColumn get updatedAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(
        const FunctionCallExpression('now', []),
      )();

  TimestampColumn get createdAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(
        const FunctionCallExpression('now', []),
      )();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

extension MessageToResponse on Message {
  Map<String, dynamic> toResponse() {
    return {
      ...toJson(),
      'updatedAt': updatedAt.dateTime.toIso8601String(),
      'createdAt': createdAt.dateTime.toIso8601String(),
    };
  }
}
