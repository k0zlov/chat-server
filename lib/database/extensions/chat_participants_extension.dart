import 'package:chat_server/database/database.dart';
import 'package:chat_server/database/extensions/users_extension.dart';
import 'package:chat_server/exceptions/api_exception.dart';
import 'package:chat_server/models/chat_participant.dart';
import 'package:chat_server/tables/chat_participants.dart';
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
          }
        case ChatParticipantRole.admin:
        case ChatParticipantRole.member:
          {
            await chatParticipants.replaceOne(
              targetParticipant.copyWith(role: newRole),
            );
          }
      }

      return getChatParticipants(chatId: chatId);
    });
  }
}
