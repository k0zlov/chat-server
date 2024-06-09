import 'package:chat_server/database/database.dart';
import 'package:chat_server/exceptions/api_exception.dart';
import 'package:drift/drift.dart';

/// Extension for handling pinned chats.
extension PinnedChatsExtension on Database {
  /// Pins a chat for a user.
  Future<void> pinChat({
    required int chatId,
    required int userId,
  }) {
    return transaction<void>(() async {
      final int count = await pinnedChats
          .count(
            where: (tbl) =>
                tbl.userId.equals(userId) & tbl.chatId.equals(chatId),
          )
          .getSingle();

      if (count > 0) {
        throw const ApiException.badRequest(
          'This chat is already pinned',
        );
      }

      try {
        await pinnedChats.insertReturning(
          PinnedChatsCompanion.insert(chatId: chatId, userId: userId),
        );
      } catch (e) {
        throw const ApiException.internalServerError(
          'Could not pin chat',
        );
      }
    });
  }

  /// Unpins a chat for a user.
  Future<void> unpinChat({
    required int chatId,
    required int userId,
  }) {
    return transaction<void>(() async {
      final bool result = await pinnedChats.deleteOne(
        PinnedChat(chatId: chatId, userId: userId),
      );

      if (!result) {
        throw const ApiException.badRequest(
          'This chat is not pinned',
        );
      }
    });
  }

  /// Retrieves all pinned chats for a user.
  Future<List<PinnedChat>> getPinnedChats({
    required int userId,
  }) {
    return transaction<List<PinnedChat>>(() async {
      final query = pinnedChats.select()
        ..where(
          (tbl) => tbl.userId.equals(userId),
        );

      final List<PinnedChat> chats = await query.get();

      return chats;
    });
  }

  /// Checks if a chat is pinned by a user.
  Future<bool> checkIfChatPinned({
    required int chatId,
    required int userId,
  }) async {
    final query = pinnedChats.select()
      ..whereSamePrimaryKey(PinnedChat(chatId: chatId, userId: userId));

    final PinnedChat? chat = await query.getSingleOrNull();

    return chat != null;
  }

}
