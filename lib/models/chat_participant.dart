import 'package:chat_server/database/database.dart';
import 'package:chat_server/tables/chat_participants.dart';

/// Model class to hold chat participant information.
class ChatParticipantModel {
  /// Basic constructor of [ChatParticipantModel]
  const ChatParticipantModel({
    required this.participant,
    required this.user,
  });

  /// The chat participant information.
  final ChatParticipant participant;

  /// The user data of chat participant
  final User user;

  /// Converts the [ChatParticipantModel] instance to a map for JSON response.
  Map<String, dynamic> toJson() {
    return {
      ...participant.toResponse(),
      'name': user.name,
      'lastActivityAt': user.lastActivityAt.dateTime.toIso8601String(),
    };
  }
}
