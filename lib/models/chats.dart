import 'package:chat_server/database/database.dart';
import 'package:chat_server/models/chat_participants.dart';
import 'package:chat_server/models/messages.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

/// Enum representing the types of chats.
enum ChatType {
  /// Does not appear in public search
  private,

  /// Is open for every user
  group,

  /// Is open for all users, but read-only
  channel,
}

/// Table schema for chats.
class Chats extends Table {
  /// Unique identifier for each chat.
  IntColumn get id => integer().autoIncrement()();

  /// Type of the chat, with a default value of 'group'.
  TextColumn get type =>
      textEnum<ChatType>().withDefault(Constant(ChatType.group.name))();

  /// Title of the chat.
  TextColumn get title => text()();

  /// Description of the chat, which can be nullable.
  TextColumn get description => text().nullable()();

  /// Timestamp when the chat was created, with a default value of the current timestamp.
  TimestampColumn get createdAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(
        const FunctionCallExpression('now', []),
      )();

  /// Defines the primary key for the table as the chat ID.
  @override
  Set<Column<Object>>? get primaryKey => {id};
}

/// Extension on [Chat] to convert it to a JSON response format.
extension ChatToResponse on Chat {
  /// Converts the [Chat] instance to a map for JSON response.
  Map<String, dynamic> toResponse() {
    return {
      ...toJson(),
      'createdAt': createdAt.dateTime.toIso8601String(),
    };
  }
}

/// Container class to hold chat information, including participants and messages.
class ChatContainer {
  /// Basic constructor of [ChatContainer]
  const ChatContainer({
    required this.chat,
    required this.participants,
    required this.messages,
  });

  /// The chat information.
  final Chat chat;

  /// List of participants in the chat.
  final List<ChatParticipantContainer> participants;

  /// List of messages in the chat.
  final List<Message> messages;

  @override
  String toString() {
    return 'ChatContainer{chat: $chat, participants: $participants}';
  }

  /// Converts the [ChatContainer] instance to a map for JSON response.
  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> participantsResponse =
        participants.map((container) => container.toJson()).toList();

    final List<Map<String, dynamic>> messagesResponse =
        messages.map((message) => message.toResponse()).toList();

    return {
      ...chat.toResponse(),
      'participants': participantsResponse,
      'messages': messagesResponse,
    };
  }
}
