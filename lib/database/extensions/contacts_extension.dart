import 'package:chat_server/database/database.dart';
import 'package:chat_server/exceptions/api_exception.dart';
import 'package:chat_server/models/contacts.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';

/// Extension on the [Database] class to handle contacts-related operations.
extension ContactsExtension on Database {
  /// Retrieves a list of [ContactContainer] for the given user.
  ///
  /// This method performs a transaction to fetch the contacts associated with
  /// the specified user ID. It first checks if the user exists, then retrieves
  /// the contacts and the corresponding user details to construct the contact
  /// containers.
  ///
  /// Parameters:
  ///   [userId] The ID of the user whose contacts are to be retrieved.
  ///
  /// Returns:
  ///   A Future that resolves to a list of [ContactContainer] instances.
  Future<List<ContactContainer>> getAllContacts({
    required int userId,
  }) {
    return transaction<List<ContactContainer>>(() async {
      final query = contacts.select()
        ..where((tbl) => tbl.userId.equals(userId));

      final List<Contact> userContacts = await query.get();

      final List<int> contactIds =
          userContacts.map((contact) => contact.contactUserId).toList();

      if (contactIds.isEmpty) {
        return [];
      }

      final usersQuery = users.select()
        ..where((tbl) => tbl.id.isIn(contactIds));

      final List<User> allUsers = await usersQuery.get();

      final List<ContactContainer> containers = [];

      for (final contact in userContacts) {
        final User? user = allUsers
            .firstWhereOrNull((user) => user.id == contact.contactUserId);

        containers.add(
          ContactContainer(
            contact: contact,
            name: user?.name ?? '',
            email: user?.email ?? '',
            lastActivity: user?.lastActivityAt.dateTime ?? DateTime.now(),
          ),
        );
      }

      return containers;
    });
  }

  /// Adds a contact for the user with the specified [userId] and [contactUserEmail].
  ///
  /// This method ensures that:
  /// - A user cannot add themselves as a contact.
  /// - The target user exists in the database.
  /// - The contact does not already exist.
  ///
  /// Throws an [ApiException.badRequest] if any of these conditions are not met.
  ///
  /// Returns the newly added [Contact].
  Future<ContactContainer> addContact({
    required int userId,
    required String contactUserEmail,
  }) {
    return transaction<ContactContainer>(() async {
      final User? target = await (users.select()
            ..where((tbl) => tbl.email.equals(contactUserEmail)))
          .getSingleOrNull();

      if (target == null) {
        const String errorMessage = 'There is no user with such email';
        throw const ApiException.badRequest(errorMessage);
      }

      if (userId == target.id) {
        const String errorMessage = 'You cannot add yourself in contacts';
        throw const ApiException.badRequest(errorMessage);
      }

      final query = contacts.count(
        where: (tbl) =>
            tbl.userId.equals(userId) & tbl.contactUserId.equals(target.id),
      );

      final int count = await query.getSingle();

      if (count > 0) {
        const String errorMessage = 'This user is already in your contacts';
        throw const ApiException.badRequest(errorMessage);
      }

      final Contact? contact = await contacts.insertReturningOrNull(
        ContactsCompanion.insert(
          userId: userId,
          contactUserId: target.id,
        ),
      );

      if (contact == null) {
        const String errorMessage = 'Could not add contact';
        throw const ApiException.badRequest(errorMessage);
      }

      final ContactContainer container = ContactContainer(
        contact: contact,
        name: target.name,
        email: target.email,
        lastActivity: target.lastActivityAt.dateTime,
      );

      return container;
    });
  }

  /// Removes a contact for the user with the specified [userId] and [contactUserEmail].
  ///
  /// This method ensures that:
  /// - The contact exists in the database.
  ///
  /// Throws an [ApiException.badRequest] if the contact does not exist.
  /// Throws an [ApiException.internalServerError] if the contact cannot be removed.
  Future<void> removeContact({
    required int userId,
    required String contactUserEmail,
  }) {
    return transaction<void>(() async {
      final User? target = await (users.select()
            ..where((tbl) => tbl.email.equals(contactUserEmail)))
          .getSingleOrNull();

      if (target == null) {
        const String errorMessage = 'There is no user with such email';
        throw const ApiException.badRequest(errorMessage);
      }

      final query = contacts.select()
        ..where(
          (tbl) =>
              tbl.userId.equals(userId) & tbl.contactUserId.equals(target.id),
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
