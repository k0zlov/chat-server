import 'package:chat_server/database/database.dart';
import 'package:chat_server/database/extensions/chat_participants_extension.dart';
import 'package:chat_server/database/extensions/chats_extension.dart';
import 'package:chat_server/database/extensions/users_extension.dart';
import 'package:chat_server/exceptions/api_exception.dart';
import 'package:chat_server/models/message.dart';
import 'package:chat_server/tables/chat_participants.dart';
import 'package:chat_server/tables/chats.dart';
import 'package:chat_server/tables/users.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

/// Extension for performing database operations related to Messages
extension MessagesExtension on Database {
  /// Retrieves a message by its ID.
  ///
  /// Returns the [Message] if found, otherwise returns null.
  /// Throws [ApiException] if there is an error fetching the message.
  Future<Message?> getMessage({
    required int messageId,
  }) async {
    final query = messages.select()
      ..where(
        (tbl) => tbl.id.equals(messageId),
      );

    final Message? message = await query.getSingleOrNull();
    return message;
  }

  /// Retrieves a message by its ID or throws an exception if it does not exist.
  ///
  /// Throws [ApiException] if the message does not exist.
  Future<Message> getMessageOrThrow({
    required int messageId,
  }) async {
    final Message? message = await getMessage(
      messageId: messageId,
    );

    if (message == null) {
      throw const ApiException.badRequest(
        'There is no message with such id',
      );
    }

    return message;
  }

  /// Sends a message in a specified chat.
  ///
  /// Throws [ApiException] if the chat does not exist, if the user does not have permission,
  /// or if the message could not be created.
  Future<MessageModel> sendMessage({
    required User user,
    required int chatId,
    required String content,
  }) {
    return transaction<MessageModel>(() async {
      final Chat chat = await getChatOrThrow(chatId);

      final ChatParticipant participant =
          await getChatParticipantOrThrow(userId: user.id, chatId: chatId);

      if (chat.type == ChatType.channel) {
        final List<ChatParticipantRole> accessRoles = [
          ChatParticipantRole.owner,
          ChatParticipantRole.admin,
        ];

        if (!accessRoles.contains(participant.role)) {
          throw const ApiException.badRequest(
            'You must be admin or owner of channel to send messages in it',
          );
        }
      }

      if (content.isEmpty) {
        throw const ApiException.badRequest(
          'Content length must be at least 1 letter',
        );
      }

      final Message? message = await messages.insertReturningOrNull(
        MessagesCompanion.insert(
          content: content,
          userId: user.id,
          chatId: chatId,
        ),
      );

      if (message == null) {
        throw const ApiException.internalServerError(
          'Could not send message',
        );
      }

      final MessageModel model = MessageModel(
        message: message,
        user: user,
      );

      return model;
    });
  }

  /// Deletes a message by its ID.
  ///
  /// Throws [ApiException] if the message does not exist, if the user does not have permission,
  /// or if the message could not be deleted.
  Future<void> deleteMessage({
    required int messageId,
    required int userId,
  }) {
    return transaction<void>(() async {
      final Message message = await getMessageOrThrow(messageId: messageId);

      final Chat chat = await getChatOrThrow(message.chatId);

      final ChatParticipant participant = await getChatParticipantOrThrow(
        userId: userId,
        chatId: chat.id,
      );

      final List<ChatParticipantRole> accessRoles = [
        ChatParticipantRole.owner,
        ChatParticipantRole.admin,
      ];

      final bool canDeleteMessage =
          message.userId == userId || accessRoles.contains(participant.role);

      if (!canDeleteMessage) {
        throw const ApiException.badRequest(
          'You must be message author or chat admin to delete this message',
        );
      }

      final bool result = await messages.deleteOne(message);

      if (!result) {
        throw const ApiException.internalServerError(
          'Could not delete message',
        );
      }
    });
  }

  /// Updates a message by its ID.
  ///
  /// Throws [ApiException] if the message does not exist, if the user does not have permission,
  /// or if the message could not be updated.
  Future<MessageModel> updateMessage({
    required int messageId,
    required User user,
    required String content,
  }) {
    return transaction<MessageModel>(() async {
      final Message message = await getMessageOrThrow(
        messageId: messageId,
      );

      final Chat chat = await getChatOrThrow(message.chatId);

      final participant = await getChatParticipantOrThrow(
        userId: user.id,
        chatId: chat.id,
      );

      final List<ChatParticipantRole> accessRoles = [
        ChatParticipantRole.owner,
        ChatParticipantRole.admin,
      ];

      final bool canUpdateMessage =
          message.userId == user.id || accessRoles.contains(participant.role);

      if (!canUpdateMessage) {
        throw const ApiException.badRequest(
          'You must be message author or chat admin to update this message',
        );
      }

      final Message modifiedMessage = message.copyWith(
        content: content,
        updatedAt: PgDateTime(DateTime.now()),
      );

      final bool result = await messages.update().replace(modifiedMessage);

      if (!result) {
        throw const ApiException.internalServerError(
          'Could not update message',
        );
      }

      final User? messageAuthor = await getUserFromId(
        userId: modifiedMessage.userId,
      );

      if (messageAuthor == null) {
        throw const ApiException.internalServerError(
          'Could not find message author',
        );
      }

      final MessageModel model = MessageModel(
        message: message,
        user: messageAuthor,
      );

      return model;
    });
  }

  /// Retrieves all messages in a given chat.
  ///
  /// Returns a list of [Message] objects.
  /// Throws [ApiException] if there is an error fetching the messages
  Future<List<MessageModel>> getAllMessages({required int chatId}) async {
    final query = messages.select()
      ..where(
        (tbl) => tbl.chatId.equals(chatId),
      );

    final List<Message> chatMessages = await query.get();

    final List<int> authorIds =
        chatMessages.map((message) => message.userId).toList();

    if (authorIds.isEmpty) return [];

    final authorQuery = users.select()..where((tbl) => tbl.id.isIn(authorIds));

    final List<User> authors = await authorQuery.get();

    final List<MessageModel> models = chatMessages
        .map(
          (m) => MessageModel(
            message: m,
            user: authors.singleWhereOrNull((a) => a.id == m.userId) ??
                UserDataExtension.notFoundUser,
          ),
        )
        .toList();

    return models;
  }
}
