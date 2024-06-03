import 'package:chat_server/models/posts.dart';
import 'package:drift/drift.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Posts])
class Database extends _$Database {
  Database(super.e);

  @override
  int get schemaVersion => 1;
}
