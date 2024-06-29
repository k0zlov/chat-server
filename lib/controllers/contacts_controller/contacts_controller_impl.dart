import 'dart:convert';

import 'package:chat_server/controllers/contacts_controller/contacts_controller.dart';
import 'package:chat_server/database/database.dart';
import 'package:chat_server/database/extensions/contacts_extension.dart';
import 'package:chat_server/exceptions/api_exception.dart';
import 'package:chat_server/models/contact.dart';
import 'package:chat_server/utils/request_validator.dart';
import 'package:drift/drift.dart';
import 'package:shelf/shelf.dart';

/// Implementation of [ContactsController] for managing user contacts.
class ContactsControllerImpl implements ContactsController {
  /// Creates an instance of [ContactsControllerImpl] with the required [database].
  const ContactsControllerImpl({
    required this.database,
  });

  /// The database instance used for querying and modifying contact data.
  final Database database;

  @override
  Future<Response> getAll(Request request) async {
    final User user = request.context['user']! as User;

    final List<ContactModel> containers = await database.getAllContacts(
      userId: user.id,
    );

    final List<Map<String, dynamic>> response = [];

    for (final container in containers) {
      response.add(container.toJson());
    }

    return Response.ok(jsonEncode(response));
  }

  @override
  Future<Response> add(Request request) async {
    final Map<String, dynamic> body =
        RequestValidator.getBodyFromContext(request);

    final String contactUserEmail = body['contactUserEmail'] as String;

    final User user = request.context['user']! as User;

    final ContactModel container = await database.addContact(
      userId: user.id,
      contactUserEmail: contactUserEmail,
    );

    return Response.ok(jsonEncode(container.toJson()));
  }

  @override
  Future<Response> remove(Request request) async {
    final Map<String, dynamic> body =
        RequestValidator.getBodyFromContext(request);

    final String contactUserEmail = body['contactUserEmail'] as String;

    final User user = request.context['user']! as User;

    try {
      await database.removeContact(
        userId: user.id,
        contactUserEmail: contactUserEmail,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const ApiException.internalServerError(
        'There was an error while removing contact',
      );
    }

    return Response.ok(jsonEncode('Successfully removed user from contacts'));
  }

  @override
  Future<Response> search(Request request) async {
    final String username = request.url.queryParameters['username']!;

    final User user = request.context['user']! as User;

    final List<ContactModel> userContacts = await database.getAllContacts(
      userId: user.id,
    );

    final List<int> contactIds = userContacts
        .map((container) => container.contact.contactUserId)
        .toList();

    final query = database.users.select()
      ..where(
        (tbl) => tbl.name.contains(username) & tbl.id.isNotIn(contactIds),
      );

    final List<User> users = await query.get();

    final List<Map<String, dynamic>> response = [];

    for (final User u in users) {
      if (u.id == user.id) continue;

      response.add({
        'contactUserId': u.id,
        'name': u.name,
        'email': u.email,
        'lastActivityAt': u.lastActivityAt.dateTime.toIso8601String(),
      });
    }

    return Response.ok(jsonEncode(response));
  }
}
