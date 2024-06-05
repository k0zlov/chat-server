import 'package:chat_server/models/chat_participants.dart';
import 'package:chat_server/models/chats.dart';
import 'package:chat_server/models/contacts.dart';
import 'package:chat_server/models/posts.dart';
import 'package:chat_server/models/users.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Posts, Users, Chats, Contacts, ChatParticipants])
class Database extends _$Database {
  Database(super.e);

  @override
  int get schemaVersion => 1;
}
