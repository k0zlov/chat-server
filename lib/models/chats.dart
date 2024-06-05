import 'package:chat_server/database/database.dart';
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

class ChatContainer {
  const ChatContainer({
    required this.chat,
    required this.participants,
  });

  final Chat chat;
  final List<ChatParticipant> participants;

  @override
  String toString() {
    return 'ChatContainer{chat: $chat, participants: $participants}';
  }

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> participantsJson = [];

    for (final participant in participants) {
      participantsJson.add({
        ...participant.toJson(),
        'joinedAt': participant.joinedAt.dateTime.toIso8601String(),
      });
    }

    return {
      ...chat.toJson(),
      'createdAt': chat.createdAt.dateTime.toIso8601String(),
      'participants': participantsJson,
    };
  }
}
