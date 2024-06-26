import 'package:chat_server/database/database.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

/// Table schema for users.
class Users extends Table {
  /// Unique identifier for each user.
  IntColumn get id => integer().autoIncrement()();

  /// Name of the user.
  TextColumn get name => text()();

  /// Bio of the user.
  TextColumn get bio => text().nullable()();

  /// Email of the user, must be unique.
  TextColumn get email => text().unique()();

  /// Password of the user, with a minimum length constraint.
  TextColumn get password => text().withLength(min: 6)();

  /// Refresh token of the user, must be unique.
  TextColumn get refreshToken => text().unique()();

  /// Activation code for the user, must be unique.
  TextColumn get activation => text().unique()();

  /// Indicates whether the user is activated, with a default value of false.
  BoolColumn get isActivated => boolean().withDefault(const Constant(false))();

  /// Timestamp when the user had last activity, with a default value of the current timestamp.
  TimestampColumn get lastActivityAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(
        const FunctionCallExpression('now', []),
      )();

  /// Timestamp when the user was created, with a default value of the current timestamp.
  TimestampColumn get createdAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(
        const FunctionCallExpression('now', []),
      )();

  /// Defines the primary key for the table as the user ID.
  @override
  Set<Column<Object>>? get primaryKey => {id};
}

/// Extension on [User] to convert it to a JSON response format.
extension UserDataExtension on User {
  /// Not found user when performing database operations and couldn't find user.
  static User notFoundUser = User(
    id: -1,
    name: 'Not found',
    email: 'Not found',
    password: 'Not found',
    refreshToken: 'Not found',
    activation: 'Not found',
    isActivated: false,
    lastActivityAt: PgDateTime(DateTime.now()),
    createdAt: PgDateTime(DateTime.now()),
  );

  /// Converts the [User] instance to a map for JSON response.
  Map<String, dynamic> toResponse() {
    return {
      ...toJson(),
      'createdAt': createdAt.dateTime.toIso8601String(),
      'lastActivityAt': lastActivityAt.dateTime.toIso8601String(),
    };
  }
}
