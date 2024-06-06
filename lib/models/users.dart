import 'package:chat_server/database/database.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

/// Table schema for users.
class Users extends Table {
  /// Unique identifier for each user.
  IntColumn get id => integer().autoIncrement()();

  /// Name of the user.
  TextColumn get name => text()();

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
extension UserToResponse on User {
  /// Converts the [User] instance to a map for JSON response.
  Map<String, dynamic> toResponse() {
    return {
      ...toJson(),
      'createdAt': createdAt.dateTime.toIso8601String(),
    };
  }
}
