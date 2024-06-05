import 'package:chat_server/models/chats.dart';
import 'package:chat_server/models/users.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

enum ChatParticipantRole {
  owner,
  admin,
  member,
  readonly,
}

class ChatParticipants extends Table {
  @ReferenceName('chatParticipantChats')
  IntColumn get chatId =>
      integer().references(Chats, #id, onDelete: KeyAction.cascade)();

  @ReferenceName('chatParticipantUsers')
  IntColumn get userId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();

  TextColumn get role => textEnum<ChatParticipantRole>()
      .withDefault(Constant(ChatParticipantRole.member.name))();

  TimestampColumn get joinedAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(
        const FunctionCallExpression('now', []),
      )();

  @override
  Set<Column<Object>>? get primaryKey => {chatId, userId};
}
