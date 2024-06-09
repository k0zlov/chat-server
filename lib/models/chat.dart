import 'package:chat_server/database/database.dart';
import 'package:chat_server/models/chat_participant.dart';
import 'package:chat_server/models/message.dart';
import 'package:chat_server/tables/chats.dart';

/// Model class to hold chat information, including participants and messages.
class ChatModel {
  /// Basic constructor of [ChatModel]
  const ChatModel({
    required this.chat,
    required this.participants,
    required this.messages,
  });

  /// The chat information.
  final Chat chat;

  /// List of participants in the chat.
  final List<ChatParticipantModel> participants;

  /// List of messages in the chat.
  final List<MessageModel> messages;

  @override
  String toString() {
    return 'ChatModel{chat: $chat, participants: $participants}';
  }

  /// Converts the [ChatModel] instance to a map for JSON response.
  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> participantsResponse =
        participants.map((model) => model.toJson()).toList();

    final List<Map<String, dynamic>> messagesResponse =
        messages.map((model) => model.toJson()).toList();

    return {
      ...chat.toResponse(),
      'participants': participantsResponse,
      'messages': messagesResponse,
    };
  }
}
