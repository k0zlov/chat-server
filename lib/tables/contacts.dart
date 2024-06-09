import 'package:chat_server/database/database.dart';
import 'package:chat_server/tables/users.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

/// Table schema for contacts.
class Contacts extends Table {
  /// References the user ID from the [Users] table, with cascade delete.
  @ReferenceName('contactOwners')
  IntColumn get userId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();

  /// References the contact user ID from the [Users] table, with cascade delete.
  @ReferenceName('contactTargets')
  IntColumn get contactUserId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();

  /// Timestamp when the contact was added, with a default value of the current timestamp.
  TimestampColumn get addedAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(
        const FunctionCallExpression('now', []),
      )();

  /// Defines the primary key for the table as a combination of userId and contactUserId.
  @override
  Set<Column> get primaryKey => {userId, contactUserId};

  /// Adds a custom constraint to ensure a user cannot add themselves as a contact.
  @override
  List<String> get customConstraints => [
        'CHECK (user_id <> contact_user_id)',
      ];
}

/// Extension on [Contact] to convert it to a JSON response format.
extension ContactDataExtension on Contact {
  /// Converts the [Contact] instance to a map for JSON response.
  Map<String, dynamic> toResponse() {
    return {
      ...toJson(),
      'addedAt': addedAt.dateTime.toIso8601String(),
    };
  }
}
