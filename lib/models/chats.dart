import 'package:chat_server/database/database.dart';
import 'package:chat_server/models/chat_participants.dart';
import 'package:chat_server/models/messages.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

enum ChatType {
  private,
  group,
  channel,
}

class Chats extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get type =>
      textEnum<ChatType>().withDefault(Constant(ChatType.group.name))();

  TextColumn get title => text()();

  TextColumn get description => text().nullable()();

  TimestampColumn get createdAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(
        const FunctionCallExpression('now', []),
      )();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

extension ChatToResponse on Chat {
  Map<String, dynamic> toResponse() {
    return {
      ...toJson(),
      'createdAt': createdAt.dateTime.toIso8601String(),
    };
  }
}

class ChatContainer {
  const ChatContainer({
    required this.chat,
    required this.participants,
    required this.messages,
  });

  final Chat chat;
  final List<ChatParticipant> participants;
  final List<Message> messages;

  @override
  String toString() {
    return 'ChatContainer{chat: $chat, participants: $participants}';
  }

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> participantsResponse = [];

    for (final participant in participants) {
      participantsResponse.add(participant.toResponse());
    }

    final List<Map<String, dynamic>> messagesResponse = [];

    for (final message in messages) {
      messagesResponse.add(message.toResponse());
    }

    return {
      ...chat.toResponse(),
      'participants': participantsResponse,
      'messages': messagesResponse,
    };
  }
}
