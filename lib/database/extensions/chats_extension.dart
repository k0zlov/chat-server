import 'package:chat_server/database/database.dart';
import 'package:chat_server/database/extensions/chat_participants_extension.dart';
import 'package:chat_server/database/extensions/messages_extension.dart';
import 'package:chat_server/exceptions/api_exception.dart';
import 'package:chat_server/models/chat_participants.dart';
import 'package:chat_server/models/chats.dart';
import 'package:drift/drift.dart';

/// Extension for performing database operations related to Chats
extension ChatsExtension on Database {
  /// Creates a new chat with the specified title, type, and description.
  ///
  /// Assigns the user as the owner of the chat.
  ///
  /// Throws [ApiException] if the chat or chat participant could not be created.
  Future<ChatContainer> createChat({
    required int userId,
    required String title,
    required ChatType? chatType,
    required String? description,
  }) async {
    return transaction<ChatContainer>(() async {
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
        userId: userId,
      ).copyWith(role: const Value(ChatParticipantRole.owner));

      final ChatParticipant? participant = await chatParticipants
          .insert()
          .insertReturningOrNull(participantsCompanion);

      if (participant == null) {
        throw const ApiException.internalServerError(
          'Could not create chat participant',
        );
      }

      return ChatContainer(
        chat: chat,
        participants: [participant],
        messages: [],
      );
    });
  }

  /// Deletes a chat if the requester is the owner of the chat.
  ///
  /// Throws [ApiException] if the chat does not exist or the requester is not the owner.
  Future<bool> deleteChat({
    required int chatId,
    required int ownerId,
  }) async {
    return transaction<bool>(() async {
      final chat = await getChatOrThrow(chatId);

      final ownerQuery = chatParticipants.select()
        ..where(
          (tbl) =>
              tbl.chatId.equals(chatId) &
              tbl.userId.equals(ownerId) &
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
  Future<ChatContainer> updateChat({
    required Chat chat,
    required int userId,
  }) async {
    return transaction<ChatContainer>(() async {
      final authorQuery = chatParticipants.select()
        ..where(
          (tbl) => tbl.chatId.equals(chat.id) & tbl.userId.equals(userId),
        );

      final ChatParticipant? requestAuthor =
          await authorQuery.getSingleOrNull();

      if (requestAuthor == null) {
        throw const ApiException.badRequest(
          'You are not member of this chat',
        );
      }

      final List<ChatParticipantRole> accessRoles = [
        ChatParticipantRole.owner,
        ChatParticipantRole.admin,
      ];

      if (!accessRoles.contains(requestAuthor.role)) {
        throw const ApiException.badRequest(
          'You must be the admin or owner of the chat to update it',
        );
      }

      final bool result = await chats.update().replace(chat);

      if (!result) {
        const errorMessage = 'Could not update chat';
        throw const ApiException.internalServerError(errorMessage);
      }

      final List<ChatParticipant> participants = await getChatParticipants(
        chatId: chat.id,
      );

      final List<Message> messages = await getAllMessages(
        chatId: chat.id,
      );

      final ChatContainer container = ChatContainer(
        chat: chat,
        participants: participants,
        messages: messages,
      );

      return container;
    });
  }

  /// Searches for chats by title.
  ///
  /// Excludes private chats from the results.
  ///
  /// Throws [ApiException] if there is an error during the search.
  Future<List<ChatContainer>> searchChats({required String title}) async {
    return transaction<List<ChatContainer>>(() async {
      final chatsQuery = chats.select()
        ..where(
          (tbl) =>
              tbl.title.contains(title) &
              tbl.type.isNotInValues(<ChatType>[ChatType.private]),
        );

      final List<Chat> searchedChats = await chatsQuery.get();

      final List<ChatContainer> containers = [];

      for (final chat in searchedChats) {
        containers.add(
          ChatContainer(
            chat: chat,
            participants: await getChatParticipants(chatId: chat.id),
            messages: await getAllMessages(chatId: chat.id),
          ),
        );
      }

      return containers;
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

  /// Adds a user to a chat.
  ///
  /// Throws [ApiException] if the chat does not exist or the user is already in the chat.
  Future<void> joinChat({required int chatId, required int userId}) async {
    return transaction<void>(() async {
      await getChatOrThrow(chatId);

      final participantQuery = chatParticipants.select()
        ..where((tbl) => tbl.userId.equals(userId) & tbl.chatId.equals(chatId));

      final ChatParticipant? participant =
          await participantQuery.getSingleOrNull();

      if (participant != null) {
        throw const ApiException.badRequest('You are already in this chat');
      }

      final ChatParticipant? result = await chatParticipants
          .insert()
          .insertReturningOrNull(
            ChatParticipantsCompanion.insert(chatId: chatId, userId: userId),
          );

      if (result == null) {
        throw const ApiException.internalServerError(
          'Could not create chat participant',
        );
      }
    });
  }

  /// Removes a user from a chat.
  ///
  /// Throws [ApiException] if the chat does not exist or the user is not in the chat.
  Future<void> leaveChat({
    required int chatId,
    required int userId,
  }) async {
    return transaction<void>(() async {
      await getChatOrThrow(chatId);

      final query = chatParticipants.select()
        ..where((tbl) => tbl.userId.equals(userId) & tbl.chatId.equals(chatId));

      final ChatParticipant? participant = await query.getSingleOrNull();

      if (participant == null) {
        throw const ApiException.badRequest('You are not in this chat');
      }

      final bool result = await chatParticipants.deleteOne(participant);
      if (!result) {
        throw const ApiException.internalServerError(
          'Could not delete chat participant',
        );
      }
    });
  }

  /// Gets all chats for a specific user.
  ///
  /// Steps:
  ///   1. Get all chat participants for the specific user.
  ///   2. Extract chat IDs from the list of user participants.
  ///   3. Get all chats where the user is a participant using the list of chat IDs.
  ///   4. Get all participants for all chats in one query.
  ///   5. Group participants by chat ID.
  ///   6. Create ChatContainer for each chat with its participants.
  ///
  /// Throws [ApiException] if there is an error retrieving the chats.
  Future<List<ChatContainer>> getUserChats({
    required int userId,
  }) async {
    return transaction<List<ChatContainer>>(() async {
      final userParticipantsQuery = chatParticipants.select()
        ..where((tbl) => tbl.userId.equals(userId));

      final List<ChatParticipant> userParticipants =
          await userParticipantsQuery.get();

      final List<int> chatIds = userParticipants.map((p) => p.chatId).toList();

      if (chatIds.isEmpty) return [];

      final chatsQuery = chats.select()..where((tbl) => tbl.id.isIn(chatIds));
      final List<Chat> userChats = await chatsQuery.get();

      final participantsQuery = chatParticipants.select()
        ..where((tbl) => tbl.chatId.isIn(chatIds));

      final List<ChatParticipant> allParticipants =
          await participantsQuery.get();

      final Map<int, List<ChatParticipant>> participantsByChatId = {};
      for (final participant in allParticipants) {
        participantsByChatId
            .putIfAbsent(participant.chatId, () => [])
            .add(participant);
      }

      final messagesQuery = messages.select()
        ..where(
          (tbl) => tbl.chatId.isIn(chatIds),
        );

      final List<Message> allMessages = await messagesQuery.get();

      final Map<int, List<Message>> messagesByChatId = {};
      for (final message in allMessages) {
        messagesByChatId.putIfAbsent(message.chatId, () => []).add(message);
      }

      final List<ChatContainer> response = userChats.map((chat) {
        return ChatContainer(
          chat: chat,
          participants: participantsByChatId[chat.id] ?? [],
          messages: messagesByChatId[chat.id] ?? [],
        );
      }).toList();

      return response;
    });
  }
}
