import 'dart:convert';

import 'package:chat_server/controllers/contacts_controller/contacts_controller.dart';
import 'package:chat_server/database/database.dart';
import 'package:chat_server/exceptions/api_exception.dart';
import 'package:chat_server/utils/request_validator.dart';
import 'package:drift/drift.dart';
import 'package:shelf/shelf.dart';

class ContactsControllerImpl implements ContactsController {
  const ContactsControllerImpl({
    required this.database,
  });

  final Database database;

  @override
  Future<Response> getAll(Request request) async {
    final int userId = request.context['userId']! as int;

    final query = database.contacts.select()
      ..where((tbl) => tbl.userId.equals(userId));

    final List<Contact> contacts = await query.get();

    final List<Map<String, dynamic>> response = [];

    for (final Contact contact in contacts) {
      response.add({
        ...contact.toJson(),
        'addedAt': contact.addedAt.dateTime.toIso8601String(),
      });
    }

    return Response.ok(jsonEncode(response));
  }

  @override
  Future<Response> add(Request request) async {
    final Map<String, dynamic> body =
        RequestValidator.getBodyFromContext(request);

    final int contactUserId = body['contactUserId'] as int;

    final int userId = request.context['userId']! as int;

    if (userId == contactUserId) {
      const String errorMessage = 'You cannot add yourself in contacts';
      throw const ApiException.badRequest(errorMessage);
    }

    final User? target = await (database.users.select()
          ..where((tbl) => tbl.id.equals(contactUserId)))
        .getSingleOrNull();

    if (target == null) {
      const String errorMessage = 'There is no user with such id';
      throw const ApiException.badRequest(errorMessage);
    }

    final query = database.contacts.count(
      where: (tbl) =>
          tbl.userId.equals(userId) & tbl.contactUserId.equals(contactUserId),
    );

    final int count = await query.getSingle();

    if (count > 0) {
      const String errorMessage = 'This user is already in your contacts';
      throw const ApiException.badRequest(errorMessage);
    }

    final Contact? contact = await database.contacts.insertReturningOrNull(
      ContactsCompanion.insert(
        userId: userId,
        contactUserId: contactUserId,
      ),
    );

    if (contact == null) {
      const String errorMessage = 'Could not add contact';
      throw const ApiException.badRequest(errorMessage);
    }

    final Map<String, dynamic> response = {
      ...contact.toJson(),
      'addedAt': contact.addedAt.dateTime.toIso8601String(),
    };

    return Response.ok(jsonEncode(response));
  }

  @override
  Future<Response> remove(Request request) async {
    final Map<String, dynamic> body =
        RequestValidator.getBodyFromContext(request);

    final int contactUserId = body['contactUserId'] as int;

    final int userId = request.context['userId']! as int;

    final query = database.contacts.select()
      ..where(
        (tbl) =>
            tbl.userId.equals(userId) & tbl.contactUserId.equals(contactUserId),
      );

    final Contact? contact = await query.getSingleOrNull();

    if (contact == null) {
      const String errorMessage = 'This user is not in your contacts';
      throw const ApiException.badRequest(errorMessage);
    }

    final bool result = await database.contacts.deleteOne(contact);

    if (!result) {
      const String errorMessage = 'Could not remove user from contacts';
      throw const ApiException.internalServerError(errorMessage);
    }

    return Response.ok('Successfully removed user from contacts');
  }

  @override
  Future<Response> search(Request request) async {
    final String username = request.url.queryParameters['username']!;

    final int userId = request.context['userId']! as int;

    final query = database.users.select()
      ..where((tbl) => tbl.name.contains(username));

    final List<User> users = await query.get();

    final List<Map<String, dynamic>> response = [];

    for (final User user in users) {
      if (user.id == userId) continue;

      response.add({
        'userId': user.id,
        'username': user.name,
        'createdAt': user.createdAt.dateTime.toIso8601String(),
      });
    }

    return Response.ok(jsonEncode(response));
  }
}
