import 'dart:convert';

import 'package:chat_server/controllers/chats_controller/chats_controller.dart';
import 'package:chat_server/database/chats_extension.dart';
import 'package:chat_server/database/database.dart';
import 'package:chat_server/exceptions/api_exception.dart';
import 'package:chat_server/models/chats.dart';
import 'package:chat_server/utils/request_validator.dart';
import 'package:drift/drift.dart';
import 'package:shelf/shelf.dart';

class ChatsControllerImpl implements ChatsController {
  const ChatsControllerImpl({
    required this.database,
  });

  /// Database instance for performing database actions.
  final Database database;

  @override
  Future<Response> getAll(Request request) async {
    final int userId = request.context['userId']! as int;

    final List<ChatContainer> chats =
        await database.getUserChats(userId: userId);

    final List<Map<String, dynamic>> response = [];

    for (final ChatContainer container in chats) {
      response.add(container.toJson());
    }

    return Response.ok(jsonEncode(response));
  }

  @override
  Future<Response> create(Request request) async {
    final int userId = request.context['userId']! as int;

    final Map<String, dynamic> body = RequestValidator.getBodyFromContext(
      request,
    );

    final String title = body['title'] as String;
    final String? description = body['description'] as String?;
    final String? chatTypeRaw = body['chatType'] as String?;

    ChatType? chatType;

    for (final ChatType type in ChatType.values) {
      if (type.name == chatTypeRaw) {
        chatType = type;
        break;
      }
    }

    if (chatTypeRaw != null && chatType == null) {
      const errorMessage = 'There is no such chat type';
      throw const ApiException.badRequest(errorMessage);
    }

    final ChatContainer container = await database.createChat(
      userId: userId,
      title: title,
      chatType: chatType,
      description: description,
    );

    return Response.ok(jsonEncode(container.toJson()));
  }

  @override
  Future<Response> delete(Request request) async {
    final int userId = request.context['userId']! as int;
    final String chatIdRaw = request.url.queryParameters['chatId']!;

    final int chatId;

    try {
      chatId = int.parse(chatIdRaw);
    } catch (e) {
      const errorMessage = 'Query parameter chatId is invalid';
      throw const ApiException.badRequest(errorMessage);
    }

    final bool result = await database.deleteChat(
      chatId: chatId,
      ownerId: userId,
    );

    if (!result) {
      const errorMessage = 'Could not delete chat';
      throw const ApiException.internalServerError(errorMessage);
    }

    return Response.ok('Successfully deleted chat');
  }

  @override
  Future<Response> update(Request request) async {
    final Map<String, dynamic> body = RequestValidator.getBodyFromContext(
      request,
    );

    final int userId = request.context['userId']! as int;

    final int chatId = body['chatId'] as int;
    final String? title = body['title'] as String?;
    final String? description = body['description'] as String?;
    final String? chatTypeRaw = body['chatType'] as String?;

    final Chat? chatOrigin = await database.getChatFromId(chatId: chatId);

    if (chatOrigin == null) {
      const errorMessage = 'There is no chat with such id';
      throw const ApiException.badRequest(errorMessage);
    }

    if (title == null &&
        chatTypeRaw == null &&
        chatOrigin.description == description) {
      const errorMessage = 'No parameters for updating chat provided';
      throw const ApiException.badRequest(errorMessage);
    }

    ChatType? chatType;

    for (final ChatType type in ChatType.values) {
      if (type.name == chatTypeRaw) {
        chatType = type;
        break;
      }
    }

    if (chatTypeRaw != null && chatType == null) {
      const errorMessage = 'There is no such chat type';
      throw const ApiException.badRequest(errorMessage);
    }

    Chat modifiedChat = chatOrigin.copyWith(
      title: title,
      type: chatType,
    );

    if (description != null) {
      modifiedChat = modifiedChat.copyWith(
        description: Value(description),
      );
    }

    final ChatContainer container = await database.updateChat(
      chat: modifiedChat,
      userId: userId,
    );

    return Response.ok(jsonEncode(container.toJson()));
  }

  @override
  Future<Response> join(Request request) async {
    final int userId = request.context['userId']! as int;

    final Map<String, dynamic> body = RequestValidator.getBodyFromContext(
      request,
    );

    final int chatId = body['chatId'] as int;

    try {
      await database.joinChat(
        chatId: chatId,
        userId: userId,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      const errorMessage = 'Could not get user into chat';
      throw const ApiException.internalServerError(errorMessage);
    }

    return Response.ok('Successfully joined chat');
  }

  @override
  Future<Response> leave(Request request) async {
    final int userId = request.context['userId']! as int;

    final Map<String, dynamic> body = RequestValidator.getBodyFromContext(
      request,
    );

    final int chatId = body['chatId'] as int;

    try {
      await database.leaveChat(
        chatId: chatId,
        userId: userId,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      const errorMessage = 'Could not get user out of chat';
      throw const ApiException.internalServerError(errorMessage);
    }

    return Response.ok('Successfully left chat');
  }

  @override
  Future<Response> search(Request request) async {
    final String title = request.url.queryParameters['title']!;

    final List<ChatContainer> containers =
        await database.searchChats(title: title);

    final List<Map<String, dynamic>> response = [];

    for (final container in containers) {
      response.add(container.toJson());
    }

    return Response.ok(jsonEncode(response));
  }
}
