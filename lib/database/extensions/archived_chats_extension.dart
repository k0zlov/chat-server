import 'package:chat_server/database/database.dart';
import 'package:chat_server/exceptions/api_exception.dart';
import 'package:drift/drift.dart';

/// Extension for handling archived chats.
extension ArchivedChatsExtension on Database {
  /// Archives a chat for a user.
  Future<void> archiveChat({
    required int chatId,
    required int userId,
  }) {
    return transaction<void>(() async {
      final int count = await archivedChats
          .count(
            where: (tbl) =>
                tbl.userId.equals(userId) & tbl.chatId.equals(chatId),
          )
          .getSingle();

      if (count > 0) {
        throw const ApiException.badRequest(
          'This chat is already archived',
        );
      }

      try {
        await archivedChats.insertReturning(
          ArchivedChatsCompanion.insert(chatId: chatId, userId: userId),
        );
      } catch (e) {
        throw const ApiException.internalServerError(
          'Could not archive chat',
        );
      }
    });
  }

  /// Unarchives a chat for a user.
  Future<void> unarchiveChat({
    required int chatId,
    required int userId,
  }) {
    return transaction<void>(() async {
      final bool result = await archivedChats.deleteOne(
        ArchivedChat(chatId: chatId, userId: userId),
      );

      if (!result) {
        throw const ApiException.badRequest(
          'This chat is not archived',
        );
      }
    });
  }

  /// Retrieves all archived chats for a user.
  Future<List<ArchivedChat>> getArchivedChats({
    required int userId,
  }) {
    return transaction<List<ArchivedChat>>(() async {
      final query = archivedChats.select()
        ..where(
          (tbl) => tbl.userId.equals(userId),
        );

      final List<ArchivedChat> chats = await query.get();

      return chats;
    });
  }

  /// Checks if a chat is archived by a user.
  Future<bool> checkIfChatArchived({
    required int chatId,
    required int userId,
  }) async {
    final query = archivedChats.select()
      ..whereSamePrimaryKey(ArchivedChat(chatId: chatId, userId: userId));

    final ArchivedChat? chat = await query.getSingleOrNull();

    return chat != null;
  }
}
