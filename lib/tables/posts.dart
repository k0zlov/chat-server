import 'package:drift/drift.dart';

/// Table schema for posts.
class Posts extends Table {
  /// Unique identifier for each post.
  IntColumn get id => integer().autoIncrement()();

  /// Subject of the post.
  TextColumn get subject => text()();

  /// Content of the post.
  TextColumn get content => text()();

  /// Defines the primary key for the table as the post ID.
  @override
  Set<Column<Object>>? get primaryKey => {id};
}
