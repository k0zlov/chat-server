import 'dart:convert';

import 'package:chat_server/controllers/contacts_controller/contacts_controller.dart';
import 'package:chat_server/database/database.dart';
import 'package:chat_server/database/extensions/contacts_extension.dart';
import 'package:chat_server/exceptions/api_exception.dart';
import 'package:chat_server/models/contacts.dart';
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
    final int userId = request.context['userId']! as int;

    final List<ContactContainer> containers = await database.getAllContacts(
      userId: userId,
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

    final int contactUserId = body['contactUserId'] as int;

    final int userId = request.context['userId']! as int;

    final ContactContainer container = await database.addContact(
      userId: userId,
      contactUserId: contactUserId,
    );

    return Response.ok(jsonEncode(container.toJson()));
  }

  @override
  Future<Response> remove(Request request) async {
    final Map<String, dynamic> body =
        RequestValidator.getBodyFromContext(request);

    final int contactUserId = body['contactUserId'] as int;

    final int userId = request.context['userId']! as int;

    try {
      await database.removeContact(
        userId: userId,
        contactUserId: contactUserId,
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

    final int userId = request.context['userId']! as int;

    final query = database.users.select()
      ..where((tbl) => tbl.name.contains(username));

    final List<User> users = await query.get();

    final List<Map<String, dynamic>> response = [];

    for (final User user in users) {
      if (user.id == userId) continue;

      response.add({
        'id': user.id,
        'username': user.name,
        'createdAt': user.createdAt.dateTime.toIso8601String(),
      });
    }

    return Response.ok(jsonEncode(response));
  }
}
