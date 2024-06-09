import 'dart:async';

import 'package:chat_server/database/database.dart';
import 'package:chat_server/database/extensions/archived_chats_extension.dart';
import 'package:chat_server/database/extensions/chat_participants_extension.dart';
import 'package:chat_server/database/extensions/messages_extension.dart';
import 'package:chat_server/database/extensions/pinned_chats_extension.dart';
import 'package:chat_server/exceptions/api_exception.dart';
import 'package:chat_server/models/chat.dart';
import 'package:chat_server/models/chat_participant.dart';
import 'package:chat_server/models/message.dart';
import 'package:chat_server/tables/chat_participants.dart';
import 'package:chat_server/tables/chats.dart';
import 'package:chat_server/tables/users.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

/// Extension for performing database operations related to Chats
extension ChatsExtension on Database {
  /// Creates a new chat with the specified title, type, and description.
  ///
  /// Assigns the user as the owner of the chat.
  ///
  /// Throws [ApiException] if the chat or chat participant could not be created.
  Future<ChatModel> createChat({
    required User user,
    required String title,
    required ChatType? chatType,
    required String? description,
  }) async {
    return transaction<ChatModel>(() async {
      final ChatsCompanion chatsCompanion = ChatsCompanion.insert(
        title: title,
        description: Value(description),
      ).copyWith(type: chatType == null ? null : Value(chatType));

      final Chat? chat = await chats.insert().insertReturningOrNull(
            chatsCompanion,
          );

      if (chat == null) {
        throw const ApiException.internalServerError('Could not create chat');
      }

      final participantsCompanion = ChatParticipantsCompanion.insert(
        chatId: chat.id,
        userId: user.id,
      ).copyWith(role: const Value(ChatParticipantRole.owner));

      final ChatParticipant? participant = await chatParticipants
          .insert()
          .insertReturningOrNull(participantsCompanion);

      if (participant == null) {
        throw const ApiException.internalServerError(
          'Could not create chat participant',
        );
      }

      final ChatParticipantModel model = ChatParticipantModel(
        participant: participant,
        user: user,
      );

      return ChatModel(
        chat: chat,
        isArchived: false,
        isPinned: false,
        participants: [model],
        messages: [],
      );
    });
  }

  /// Deletes a chat if the requester is the owner of the chat.
  ///
  /// Throws [ApiException] if the chat does not exist or the requester is not the owner.
  Future<bool> deleteChat({
    required int chatId,
    required int userId,
  }) async {
    return transaction<bool>(() async {
      final chat = await getChatOrThrow(chatId);

      final ownerQuery = chatParticipants.select()
        ..where(
          (tbl) =>
              tbl.chatId.equals(chatId) &
              tbl.userId.equals(userId) &
              tbl.role.equals(ChatParticipantRole.owner.name),
        );

      final ChatParticipant? ownerParticipant =
          await ownerQuery.getSingleOrNull();

      if (ownerParticipant == null) {
        throw const ApiException.badRequest(
          'You must be the owner of the chat to delete it',
        );
      }

      final bool result = await chats.deleteOne(chat);
      if (!result) {
        throw const ApiException.internalServerError(
          'Could not delete chat',
        );
      }
      return result;
    });
  }

  /// Updated a chat if the requester is the owner or admin of the chat.
  ///
  /// Throws [ApiException] if the requester is not the owner, admin.
  Future<ChatModel> updateChat({
    required Chat chat,
    required int userId,
  }) async {
    return transaction<ChatModel>(() async {
      final authorQuery = chatParticipants.select()
        ..where(
          (tbl) => tbl.chatId.equals(chat.id) & tbl.userId.equals(userId),
        );

      final ChatParticipant? requestAuthor =
          await authorQuery.getSingleOrNull();

      if (requestAuthor == null) {
        throw const ApiException.forbidden(
          'You are not member of this chat',
        );
      }

      final List<ChatParticipantRole> accessRoles =
          ChatParticipantDataExtension.canUpdateChatRoles;

      if (!accessRoles.contains(requestAuthor.role)) {
        throw const ApiException.forbidden(
          'You must be the admin or owner of the chat to update it',
        );
      }

      final bool result = await chats.update().replace(chat);

      if (!result) {
        const errorMessage = 'Could not update chat';
        throw const ApiException.internalServerError(errorMessage);
      }

      final List<ChatParticipantModel> participants = await getChatParticipants(
        chatId: chat.id,
      );

      final List<MessageModel> messages = await getAllMessages(
        chatId: chat.id,
      );

      final Future<bool> isPinned = checkIfChatPinned(
        userId: userId,
        chatId: chat.id,
      );

      final Future<bool> isArchived = checkIfChatArchived(
        userId: userId,
        chatId: chat.id,
      );

      final futures = await Future.wait([isArchived, isPinned]);

      final ChatModel model = ChatModel(
        chat: chat,
        isArchived: futures[0],
        isPinned: futures[1],
        participants: participants,
        messages: messages,
      );

      return model;
    });
  }

  /// Searches for chats by title.
  ///
  /// Excludes private chats from the results.
  ///
  /// Throws [ApiException] if there is an error during the search.
  Future<List<ChatModel>> searchChats({required String title}) async {
    return transaction<List<ChatModel>>(() async {
      final List<ChatType> hiddenTypes = ChatDataExtension.hiddenChatTypes;

      final chatsQuery = chats.select()
        ..where(
          (tbl) =>
              tbl.title.contains(title) & tbl.type.isNotInValues(hiddenTypes),
        );

      final List<Chat> searchedChats = await chatsQuery.get();

      final List<ChatModel> models = [];

      for (final chat in searchedChats) {
        models.add(
          ChatModel(
            chat: chat,
            isPinned: false,
            isArchived: false,
            participants: await getChatParticipants(chatId: chat.id),
            messages: await getAllMessages(chatId: chat.id),
          ),
        );
      }

      return models;
    });
  }

  /// Retrieves a chat by its ID.
  ///
  /// Returns null if the chat does not exist.
  Future<Chat?> getChatFromId({required int chatId}) async {
    final query = chats.select()..where((tbl) => tbl.id.equals(chatId));
    final Chat? chat = await query.getSingleOrNull();
    return chat;
  }

  /// Retrieves a chat by its ID or throws an exception if it does not exist.
  ///
  /// Throws [ApiException] if the chat does not exist.
  Future<Chat> getChatOrThrow(int chatId) async {
    final chat = await getChatFromId(chatId: chatId);
    if (chat == null) {
      throw const ApiException.badRequest('There is no chat with such id');
    }
    return chat;
  }

  /// Updates chat last activity
  Future<void> updateChatLastActivity({required int chatId}) async {
    try {
      final Chat chat = await getChatOrThrow(chatId);

      await chats.replaceOne(
        chat.copyWith(lastActivityAt: PgDateTime(DateTime.now())),
      );
    } catch (e) {
      print(e);
    }
  }

  /// Gets all chats for a specific user.
  ///
  /// Steps:
  ///   1. Get all chat participants for the specific user.
  ///   2. Extract chat IDs from the list of user participants.
  ///   3. Get all chats where the user is a participant using the list of chat IDs.
  ///   4. Get all participants for all chats in one query.
  ///   5. Group participants by chat ID.
  ///   6. Create ChatModel for each chat with its participants.
  ///
  /// Throws [ApiException] if there is an error retrieving the chats.
  Future<List<ChatModel>> getUserChats({
    required int userId,
  }) async {
    return transaction<List<ChatModel>>(() async {
      final List<ChatParticipant> userParticipants = await getUserParticipants(
        userId: userId,
      );

      final List<int> chatIds = userParticipants.map((p) => p.chatId).toList();

      if (chatIds.isEmpty) return [];

      final chatsQuery = chats.select()..where((tbl) => tbl.id.isIn(chatIds));
      final List<Chat> userChats = await chatsQuery.get();

      final Map<int, List<ChatParticipantModel>> participantsByChatId = {};

      for (final chat in userChats) {
        final models = await getChatParticipants(
          chatId: chat.id,
        );

        participantsByChatId.addAll({chat.id: models});
      }

      final messagesQuery = messages.select()
        ..where(
          (tbl) => tbl.chatId.isIn(chatIds),
        );

      final List<Message> allMessages = await messagesQuery.get();

      final Map<int, List<MessageModel>> messagesByChatId = {};

      final List<int> authorIds = allMessages.map((m) => m.userId).toList();

      final authorsQuery = users.select()
        ..where((tbl) => tbl.id.isIn(authorIds));

      final List<User> authors = await authorsQuery.get();

      for (final message in allMessages) {
        final User author =
            authors.singleWhereOrNull((u) => u.id == message.userId) ??
                UserDataExtension.notFoundUser;

        messagesByChatId.putIfAbsent(message.chatId, () => []).add(
              MessageModel(message: message, user: author),
            );
      }

      final Future<List<ArchivedChat>> archivedChats = getArchivedChats(
        userId: userId,
      );

      final Future<List<PinnedChat>> pinnedChats = getPinnedChats(
        userId: userId,
      );

      final futures = await Future.wait([archivedChats, pinnedChats]);

      final List<ChatModel> response = userChats.map((chat) {
        return ChatModel(
          chat: chat,
          isArchived: (futures[0] as List<ArchivedChat>).contains(
            ArchivedChat(chatId: chat.id, userId: userId),
          ),
          isPinned: (futures[1] as List<PinnedChat>).contains(
            PinnedChat(chatId: chat.id, userId: userId),
          ),
          participants: participantsByChatId[chat.id] ?? [],
          messages: messagesByChatId[chat.id] ?? [],
        );
      }).toList();

      return response;
    });
  }
}
