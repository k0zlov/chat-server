import 'dart:async';
import 'dart:convert';

import 'package:chat_server/controllers/messages_controller/messages_controller.dart';
import 'package:chat_server/database/database.dart';
import 'package:chat_server/database/extensions/chats_extension.dart';
import 'package:chat_server/database/extensions/messages_extension.dart';
import 'package:chat_server/exceptions/api_exception.dart';
import 'package:chat_server/models/message.dart';
import 'package:chat_server/utils/request_validator.dart';
import 'package:shelf/shelf.dart';

/// Implementation of the [MessagesController] interface.
///
/// This class provides concrete implementations for the methods defined in
/// the [MessagesController] interface, using a [Database] instance to perform
/// the necessary database operations.
class MessagesControllerImpl implements MessagesController {
  /// Creates a new instance of [MessagesControllerImpl].
  ///
  /// - Parameter database: The [Database] instance to use for database operations.
  const MessagesControllerImpl({
    required this.database,
  });

  /// The [Database] instance used for performing database operations.
  final Database database;

  @override
  Future<Response> send(Request request) async {
    final Map<String, dynamic> body = RequestValidator.getBodyFromContext(
      request,
    );

    final User user = request.context['user']! as User;

    final int chatId = body['chatId'] as int;
    final String content = body['content'] as String;

    final MessageModel model = await database.sendMessage(
      user: user,
      chatId: chatId,
      content: content,
    );

    unawaited(database.updateChatLastActivity(chatId: chatId));

    return Response.ok(jsonEncode(model.toJson()));
  }

  @override
  Future<Response> delete(Request request) async {
    final User user = request.context['user']! as User;

    final String messageIdRaw = request.url.queryParameters['messageId']!;

    final int messageId;

    try {
      messageId = int.parse(messageIdRaw);
    } catch (e) {
      throw const ApiException.badRequest(
        'Message id is invalid',
      );
    }

    await database.deleteMessage(
      messageId: messageId,
      userId: user.id,
    );

    return Response.ok(jsonEncode('Successfully deleted message'));
  }

  @override
  Future<Response> update(Request request) async {
    final Map<String, dynamic> body = RequestValidator.getBodyFromContext(
      request,
    );

    final User user = request.context['user']! as User;

    final int messageId = body['messageId'] as int;
    final String content = body['content'] as String;

    final MessageModel model = await database.updateMessage(
      messageId: messageId,
      user: user,
      content: content,
    );

    return Response.ok(jsonEncode(model.toJson()));
  }
}
