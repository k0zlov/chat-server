import 'package:chat_server/tables/chats.dart';
import 'package:chat_server/tables/users.dart';
import 'package:drift/drift.dart';

/// Represents a table for archived chats in the database.
///
/// This table establishes a many-to-many relationship between chats and users,
/// indicating which users have archived which chats. The table uses a composite
/// primary key consisting of `chatId` and `userId`, ensuring that each user can
/// archive a chat only once. Both columns reference their respective tables and have
/// cascading delete actions to maintain referential integrity.
class ArchivedChats extends Table {
  /// Reference to the chat that is archived.
  ///
  /// This column references the `id` column in the `Chats` table.
  /// The `onDelete: KeyAction.cascade` ensures that if a chat is deleted,
  /// all corresponding archived chat entries will also be deleted.
  @ReferenceName('archivedChats')
  IntColumn get chatId =>
      integer().references(Chats, #id, onDelete: KeyAction.cascade)();

  /// Reference to the user who archived the chat.
  ///
  /// This column references the `id` column in the `Users` table.
  /// The `onDelete: KeyAction.cascade` ensures that if a user is deleted,
  /// all corresponding archived chat entries will also be deleted.
  @ReferenceName('archivedChatUsers')
  IntColumn get userId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();

  /// Defines the composite primary key for the table.
  ///
  /// The primary key is a combination of `chatId` and `userId`, which ensures
  /// that each user can archive a specific chat only once.
  @override
  Set<Column<Object>>? get primaryKey => {chatId, userId};
}
