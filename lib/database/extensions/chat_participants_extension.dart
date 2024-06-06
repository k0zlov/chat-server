import 'package:chat_server/database/database.dart';
import 'package:chat_server/exceptions/api_exception.dart';
import 'package:drift/drift.dart';

/// Extension for performing database operations related to ChatParticipants
extension ChatParticipantsExtension on Database {
  /// Retrieves chat participants for a given chat ID.
  ///
  /// Throws [ApiException] if there is an error fetching participants.
  Future<List<ChatParticipant>> getChatParticipants({
    required int chatId,
  }) async {
    final query = chatParticipants.select()
      ..where((tbl) => tbl.chatId.equals(chatId));
    final List<ChatParticipant> participants = await query.get();
    return participants;
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
}
