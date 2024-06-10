import 'package:chat_server/database/database.dart';
import 'package:chat_server/database/extensions/chats_extension.dart';
import 'package:chat_server/exceptions/api_exception.dart';
import 'package:chat_server/models/chat.dart';
import 'package:chat_server/tables/chats.dart';
import 'package:drift/drift.dart';

/// Extension for handling archived chats.
extension ArchivedChatsExtension on Database {
  /// Archives a chat for a user.
  Future<ChatModel> archiveChat({
    required int chatId,
    required int userId,
  }) {
    return transaction<ChatModel>(() async {
      final Chat chat = await getChatOrThrow(chatId);

      if (chat.type == ChatType.savedMessages) {
        throw const ApiException.forbidden(
          'You cannot archive this chat',
        );
      }

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

      return getChatModel(chatId: chatId, userId: userId);
    });
  }

  /// Unarchives a chat for a user.
  Future<ChatModel> unarchiveChat({
    required int chatId,
    required int userId,
  }) {
    return transaction<ChatModel>(() async {
      final bool result = await archivedChats.deleteOne(
        ArchivedChat(chatId: chatId, userId: userId),
      );

      if (!result) {
        throw const ApiException.badRequest(
          'This chat is not archived',
        );
      }

      return getChatModel(chatId: chatId, userId: userId);
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
