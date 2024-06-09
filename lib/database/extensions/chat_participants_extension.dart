import 'dart:async';

import 'package:chat_server/database/database.dart';
import 'package:chat_server/database/extensions/archived_chats_extension.dart';
import 'package:chat_server/database/extensions/chats_extension.dart';
import 'package:chat_server/database/extensions/messages_extension.dart';
import 'package:chat_server/database/extensions/pinned_chats_extension.dart';
import 'package:chat_server/database/extensions/users_extension.dart';
import 'package:chat_server/exceptions/api_exception.dart';
import 'package:chat_server/models/chat.dart';
import 'package:chat_server/models/chat_participant.dart';
import 'package:chat_server/models/message.dart';
import 'package:chat_server/tables/chat_participants.dart';
import 'package:chat_server/tables/chats.dart';
import 'package:chat_server/tables/messages.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';

/// Extension for performing database operations related to ChatParticipants
extension ChatParticipantsExtension on Database {
  /// Retrieves chat participants for a given chat ID.
  ///
  /// Throws [ApiException] if there is an error fetching participants.
  Future<List<ChatParticipantModel>> getChatParticipants({
    required int chatId,
  }) async {
    final query = chatParticipants.select()
      ..where((tbl) => tbl.chatId.equals(chatId));
    final List<ChatParticipant> participants = await query.get();

    final List<ChatParticipantModel> models = [];

    for (final participant in participants) {
      final User? user = await getUserFromId(userId: participant.userId);

      models.add(
        ChatParticipantModel(
          participant: participant,
          user: user!,
        ),
      );
    }

    return models;
  }

  /// Retrieves chat participants for a given user ID.
  ///
  /// Throws [ApiException] if there is an error fetching participants.
  Future<List<ChatParticipant>> getUserParticipants({
    required int userId,
  }) {
    return transaction<List<ChatParticipant>>(() async {
      final query = chatParticipants.select()
        ..where((tbl) => tbl.userId.equals(userId));

      final List<ChatParticipant> participants = await query.get();

      return participants;
    });
  }

  /// Retrieves a chat participant for a given user ID and chat ID.
  Future<ChatParticipant?> getChatParticipant({
    required int userId,
    required int chatId,
  }) async {
    final query = chatParticipants.select()
      ..where((tbl) => tbl.userId.equals(userId) & tbl.chatId.equals(chatId));
    final ChatParticipant? participant = await query.getSingleOrNull();
    return participant;
  }

  /// Retrieves a chat participant for a given user ID and chat ID.
  ///
  /// Throws [ApiException] if there is an error fetching the participant.
  Future<ChatParticipant> getChatParticipantOrThrow({
    required int userId,
    required int chatId,
  }) async {
    final ChatParticipant? participant = await getChatParticipant(
      userId: userId,
      chatId: chatId,
    );

    if (participant == null) {
      throw const ApiException.badRequest(
        'There is no such chat participant',
      );
    }

    return participant;
  }

  /// Adds a user to a chat.
  ///
  /// Throws [ApiException] if the chat does not exist or the user is already in the chat.
  Future<ChatModel> joinChat({
    required int chatId,
    required User user,
  }) async {
    return transaction<ChatModel>(() async {
      final Chat chat = await getChatOrThrow(chatId);

      if (chat.type == ChatType.savedMessages) {
        throw const ApiException.forbidden(
          'You cannot join this chat',
        );
      }

      final List<ChatParticipantModel> participants =
          await getChatParticipants(chatId: chatId);

      final ChatParticipantModel? userParticipant = participants
          .singleWhereOrNull((p) => p.participant.userId == user.id);

      if (userParticipant != null) {
        throw const ApiException.badRequest('You are already in this chat');
      }

      final ChatParticipant? participant = await chatParticipants
          .insert()
          .insertReturningOrNull(
            ChatParticipantsCompanion.insert(chatId: chatId, userId: user.id),
          );

      if (participant == null) {
        throw const ApiException.internalServerError(
          'Could not create chat participant',
        );
      }

      final List<MessageModel> messages = await getAllMessages(chatId: chat.id);

      final MessageModel joinMessage = await sendMessage(
        user: user,
        chatId: chatId,
        content: '${user.name} joined chat',
        type: MessageType.info,
      );

      final Future<bool> isPinned = checkIfChatPinned(
        userId: user.id,
        chatId: chatId,
      );

      final Future<bool> isArchived = checkIfChatArchived(
        userId: user.id,
        chatId: chatId,
      );

      final futures = await Future.wait([isArchived, isPinned]);

      final ChatModel model = ChatModel(
        chat: chat,
        isArchived: futures[0],
        isPinned: futures[1],
        participants: [
          ...participants,
          ChatParticipantModel(participant: participant, user: user),
        ],
        messages: [...messages, joinMessage],
      );

      return model;
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
      final Chat chat = await getChatOrThrow(chatId);

      if (chat.type == ChatType.savedMessages) {
        throw const ApiException.forbidden(
          'You cannot leave from this chat',
        );
      }

      final query = chatParticipants.select()
        ..where((tbl) => tbl.userId.equals(userId) & tbl.chatId.equals(chatId));

      final ChatParticipant? participant = await query.getSingleOrNull();

      if (participant == null) {
        throw const ApiException.forbidden('You are not in this chat');
      }

      final User? user = await getUserFromId(userId: userId);

      if (user != null) {
        await sendMessage(
          user: user,
          chatId: chatId,
          content: '${user.name} left chat',
          type: MessageType.info,
        );
      }

      final bool result = await chatParticipants.deleteOne(participant);
      if (!result) {
        throw const ApiException.internalServerError(
          'Could not delete chat participant',
        );
      }
    });
  }

  /// Updates the role of a chat participant within a transaction.
  /// Only chat owners can change roles and cannot change their own role.
  /// Throws [ApiException] if constraints are violated.
  Future<List<ChatParticipantModel>> updateChatParticipant({
    required int chatId,
    required int targetId,
    required User requestUser,
    required ChatParticipantRole newRole,
  }) {
    return transaction<List<ChatParticipantModel>>(() async {
      if (requestUser.id == targetId) {
        throw const ApiException.forbidden(
          'You cannot change your role',
        );
      }

      final requestParticipant = await getChatParticipantOrThrow(
        userId: requestUser.id,
        chatId: chatId,
      );

      if (requestParticipant.role != ChatParticipantRole.owner) {
        throw const ApiException.forbidden(
          "You don't have rights to change role of chat participants",
        );
      }

      final targetParticipant = await getChatParticipantOrThrow(
        userId: targetId,
        chatId: chatId,
      );

      switch (newRole) {
        case ChatParticipantRole.owner:
          {
            await chatParticipants.replaceOne(
              requestParticipant.copyWith(role: ChatParticipantRole.admin),
            );
            await chatParticipants.replaceOne(
              targetParticipant.copyWith(role: newRole),
            );
            break;
          }
        case ChatParticipantRole.admin:
        case ChatParticipantRole.member:
          {
            await chatParticipants.replaceOne(
              targetParticipant.copyWith(role: newRole),
            );
            break;
          }
      }

      return getChatParticipants(chatId: chatId);
    });
  }
}
