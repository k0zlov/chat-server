import 'package:drift/drift.dart';

class Posts extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get subject => text()();

  TextColumn get content => text()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
