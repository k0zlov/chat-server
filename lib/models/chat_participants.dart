import 'package:chat_server/database/database.dart';
import 'package:chat_server/models/chats.dart';
import 'package:chat_server/models/users.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

/// Enum representing the roles a chat participant can have.
enum ChatParticipantRole {
  /// Owner of the chat
  owner,

  /// Admin of the chat
  admin,

  /// Simple member
  member,

  /// Can only read messages in chat
  readonly,
}

/// Table schema for chat participants.
class ChatParticipants extends Table {
  /// References the chat ID from the [Chats] table.
  @ReferenceName('chatParticipantChats')
  IntColumn get chatId =>
      integer().references(Chats, #id, onDelete: KeyAction.cascade)();

  /// References the user ID from the [Users] table.
  @ReferenceName('chatParticipantUsers')
  IntColumn get userId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();

  /// Role of the chat participant, with a default value of 'member'.
  TextColumn get role => textEnum<ChatParticipantRole>()
      .withDefault(Constant(ChatParticipantRole.member.name))();

  /// Timestamp when the user joined the chat, with a default value of the current timestamp.
  TimestampColumn get joinedAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(
        const FunctionCallExpression('now', []),
      )();

  /// Defines the primary key for the table as a combination of chatId and userId.
  @override
  Set<Column<Object>>? get primaryKey => {chatId, userId};
}

/// Extension on [ChatParticipant] to convert it to a JSON response format.
extension ChatParticipantsToResponse on ChatParticipant {
  /// Converts the [ChatParticipant] instance to a map for JSON response.
  Map<String, dynamic> toResponse() {
    return {
      ...toJson(),
      'joinedAt': joinedAt.dateTime.toIso8601String(),
    };
  }
}

/// Container class to hold chat participant information.
class ChatParticipantContainer {
  /// Basic constructor of [ChatParticipantContainer]
  const ChatParticipantContainer({
    required this.participant,
    required this.name,
  });

  /// The chat participant information.
  final ChatParticipant participant;

  /// The name of chat participant
  final String name;

  /// Converts the [ChatParticipantContainer] instance to a map for JSON response.
  Map<String, dynamic> toJson() {
    return {
      ...participant.toResponse(),
      'name': name,
    };
  }
}
