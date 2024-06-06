import 'package:chat_server/database/database.dart';
import 'package:chat_server/exceptions/api_exception.dart';
import 'package:drift/drift.dart';

/// Extension on the [Database] class to handle contacts-related operations.
extension ContactsExtension on Database {
  /// Adds a contact for the user with the specified [userId] and [contactUserId].
  ///
  /// This method ensures that:
  /// - A user cannot add themselves as a contact.
  /// - The target user exists in the database.
  /// - The contact does not already exist.
  ///
  /// Throws an [ApiException.badRequest] if any of these conditions are not met.
  ///
  /// Returns the newly added [Contact].
  Future<Contact> addContact({
    required int userId,
    required int contactUserId,
  }) {
    return transaction<Contact>(() async {
      if (userId == contactUserId) {
        const String errorMessage = 'You cannot add yourself in contacts';
        throw const ApiException.badRequest(errorMessage);
      }

      final User? target = await (users.select()
            ..where((tbl) => tbl.id.equals(contactUserId)))
          .getSingleOrNull();

      if (target == null) {
        const String errorMessage = 'There is no user with such id';
        throw const ApiException.badRequest(errorMessage);
      }

      final query = contacts.count(
        where: (tbl) =>
            tbl.userId.equals(userId) & tbl.contactUserId.equals(contactUserId),
      );

      final int count = await query.getSingle();

      if (count > 0) {
        const String errorMessage = 'This user is already in your contacts';
        throw const ApiException.badRequest(errorMessage);
      }

      final Contact? contact = await contacts.insertReturningOrNull(
        ContactsCompanion.insert(
          userId: userId,
          contactUserId: contactUserId,
        ),
      );

      if (contact == null) {
        const String errorMessage = 'Could not add contact';
        throw const ApiException.badRequest(errorMessage);
      }

      return contact;
    });
  }

  /// Removes a contact for the user with the specified [userId] and [contactUserId].
  ///
  /// This method ensures that:
  /// - The contact exists in the database.
  ///
  /// Throws an [ApiException.badRequest] if the contact does not exist.
  /// Throws an [ApiException.internalServerError] if the contact cannot be removed.
  Future<void> removeContact({
    required int userId,
    required int contactUserId,
  }) {
    return transaction<void>(() async {
      final query = contacts.select()
        ..where(
          (tbl) =>
              tbl.userId.equals(userId) &
              tbl.contactUserId.equals(contactUserId),
        );

      final Contact? contact = await query.getSingleOrNull();

      if (contact == null) {
        const String errorMessage = 'This user is not in your contacts';
        throw const ApiException.badRequest(errorMessage);
      }

      final bool result = await contacts.deleteOne(contact);

      if (!result) {
        const String errorMessage = 'Could not remove user from contacts';
        throw const ApiException.internalServerError(errorMessage);
      }
    });
  }
}
