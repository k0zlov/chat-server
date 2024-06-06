import 'package:chat_server/database/database.dart';
import 'package:chat_server/models/chats.dart';
import 'package:chat_server/models/users.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

/// Table schema for messages.
class Messages extends Table {
  /// Unique identifier for each message.
  IntColumn get id => integer().autoIncrement()();

  /// Content of the message, with a minimum length constraint.
  TextColumn get content => text().withLength(min: 1)();

  /// References the user ID from the [Users] table, with cascade delete.
  @ReferenceName('messageAuthors')
  IntColumn get userId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();

  /// References the chat ID from the [Chats] table, with cascade delete.
  @ReferenceName('messageChats')
  IntColumn get chatId =>
      integer().references(Chats, #id, onDelete: KeyAction.cascade)();

  /// Timestamp when the message was last updated, with a default value of the current timestamp.
  TimestampColumn get updatedAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(
        const FunctionCallExpression('now', []),
      )();

  /// Timestamp when the message was created, with a default value of the current timestamp.
  TimestampColumn get createdAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(
        const FunctionCallExpression('now', []),
      )();

  /// Defines the primary key for the table as the message ID.
  @override
  Set<Column<Object>>? get primaryKey => {id};
}

/// Extension on [Message] to convert it to a JSON response format.
extension MessageToResponse on Message {
  /// Converts the [Message] instance to a map for JSON response.
  Map<String, dynamic> toResponse() {
    return {
      ...toJson(),
      'updatedAt': updatedAt.dateTime.toIso8601String(),
      'createdAt': createdAt.dateTime.toIso8601String(),
    };
  }
}
