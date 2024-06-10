import 'dart:async';
import 'dart:convert';

import 'package:chat_server/controllers/chats_controller/chats_controller.dart';
import 'package:chat_server/database/database.dart';
import 'package:chat_server/database/extensions/archived_chats_extension.dart';
import 'package:chat_server/database/extensions/chat_participants_extension.dart';
import 'package:chat_server/database/extensions/chats_extension.dart';
import 'package:chat_server/database/extensions/pinned_chats_extension.dart';
import 'package:chat_server/exceptions/api_exception.dart';
import 'package:chat_server/models/chat.dart';
import 'package:chat_server/models/chat_participant.dart';
import 'package:chat_server/tables/chat_participants.dart';
import 'package:chat_server/tables/chats.dart';
import 'package:chat_server/utils/request_validator.dart';
import 'package:drift/drift.dart';
import 'package:shelf/shelf.dart';

/// Implementation of [ChatsController] for managing user chats.
class ChatsControllerImpl implements ChatsController {
  /// Creates an instance of [ChatsControllerImpl] with the required [database].
  const ChatsControllerImpl({
    required this.database,
  });

  /// Database instance for performing database actions.
  final Database database;

  @override
  Future<Response> getAll(Request request) async {
    final User user = request.context['user']! as User;

    final List<ChatModel> chats = await database.getUserChats(userId: user.id);

    final List<Map<String, dynamic>> response = [];

    for (final ChatModel model in chats) {
      response.add(model.toJson());
    }

    return Response.ok(jsonEncode(response));
  }

  @override
  Future<Response> create(Request request) async {
    final User user = request.context['user']! as User;

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

    if (chatType == ChatType.savedMessages) {
      throw const ApiException.forbidden(
        'You cannot create chat with that type',
      );
    }

    final ChatModel model = await database.createChat(
      user: user,
      title: title,
      chatType: chatType,
      description: description,
    );

    return Response.ok(jsonEncode(model.toJson()));
  }

  @override
  Future<Response> delete(Request request) async {
    final User user = request.context['user']! as User;
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
      userId: user.id,
    );

    if (!result) {
      const errorMessage = 'Could not delete chat';
      throw const ApiException.internalServerError(errorMessage);
    }

    return Response.ok(jsonEncode('Successfully deleted chat'));
  }

  @override
  Future<Response> update(Request request) async {
    final Map<String, dynamic> body = RequestValidator.getBodyFromContext(
      request,
    );

    final User user = request.context['user']! as User;

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

    if (chatType == ChatType.savedMessages) {
      throw const ApiException.forbidden(
        'You cannot update chat with that type',
      );
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

    final ChatModel model = await database.updateChat(
      chat: modifiedChat,
      userId: user.id,
    );

    unawaited(database.updateChatLastActivity(chatId: model.chat.id));

    return Response.ok(jsonEncode(model.toJson()));
  }

  @override
  Future<Response> join(Request request) async {
    final User user = request.context['user']! as User;

    final Map<String, dynamic> body = RequestValidator.getBodyFromContext(
      request,
    );

    final int chatId = body['chatId'] as int;

    final ChatModel model = await database.joinChat(
      chatId: chatId,
      user: user,
    );

    return Response.ok(jsonEncode(model.toJson()));
  }

  @override
  Future<Response> leave(Request request) async {
    final User user = request.context['user']! as User;

    final Map<String, dynamic> body = RequestValidator.getBodyFromContext(
      request,
    );

    final int chatId = body['chatId'] as int;

    try {
      await database.leaveChat(
        chatId: chatId,
        userId: user.id,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      const errorMessage = 'Could not get user out of chat';
      throw const ApiException.internalServerError(errorMessage);
    }

    return Response.ok(jsonEncode('Successfully left chat'));
  }

  @override
  Future<Response> search(Request request) async {
    final String title = request.url.queryParameters['title']!;

    final List<ChatModel> models = await database.searchChats(title: title);

    final List<Map<String, dynamic>> response = [];

    for (final model in models) {
      response.add(model.toJson());
    }

    return Response.ok(jsonEncode(response));
  }

  @override
  Future<Response> updateParticipant(Request request) async {
    final User user = request.context['user']! as User;

    final Map<String, dynamic> body = RequestValidator.getBodyFromContext(
      request,
    );

    final int chatId = body['chatId'] as int;
    final int targetId = body['targetId'] as int;
    final String rawRole = body['role'] as String;

    ChatParticipantRole? newRole;

    for (final role in ChatParticipantRole.values) {
      if (role.name == rawRole) {
        newRole = role;
        break;
      }
    }

    if (newRole == null) {
      throw const ApiException.badRequest(
        'There is no such chat participant role',
      );
    }

    final models = await database.updateChatParticipant(
      chatId: chatId,
      targetId: targetId,
      requestUser: user,
      newRole: newRole,
    );

    final List<Map<String, dynamic>> response = [];

    for (final ChatParticipantModel model in models) {
      response.add(model.toJson());
    }

    return Response.ok(jsonEncode(response));
  }

  @override
  Future<Response> archiveChat(Request request) async {
    final User user = request.context['user']! as User;

    final String chatIdRaw = request.url.queryParameters['chatId']!;

    final int chatId;

    try {
      chatId = int.parse(chatIdRaw);
    } catch (e) {
      const errorMessage = 'Query parameter chatId is invalid';
      throw const ApiException.badRequest(errorMessage);
    }

    final ChatModel model = await database.archiveChat(
      chatId: chatId,
      userId: user.id,
    );

    return Response.ok(jsonEncode(model.toJson()));
  }

  @override
  Future<Response> unarchiveChat(Request request) async {
    final User user = request.context['user']! as User;

    final String chatIdRaw = request.url.queryParameters['chatId']!;

    final int chatId;

    try {
      chatId = int.parse(chatIdRaw);
    } catch (e) {
      const errorMessage = 'Query parameter chatId is invalid';
      throw const ApiException.badRequest(errorMessage);
    }

    final ChatModel model = await database.unarchiveChat(
      chatId: chatId,
      userId: user.id,
    );

    return Response.ok(jsonEncode(model.toJson()));
  }

  @override
  Future<Response> pinChat(Request request) async {
    final User user = request.context['user']! as User;

    final String chatIdRaw = request.url.queryParameters['chatId']!;

    final int chatId;

    try {
      chatId = int.parse(chatIdRaw);
    } catch (e) {
      const errorMessage = 'Query parameter chatId is invalid';
      throw const ApiException.badRequest(errorMessage);
    }

    final ChatModel model = await database.pinChat(
      chatId: chatId,
      userId: user.id,
    );

    return Response.ok(jsonEncode(model.toJson()));
  }

  @override
  Future<Response> unpinChat(Request request) async {
    final User user = request.context['user']! as User;

    final String chatIdRaw = request.url.queryParameters['chatId']!;

    final int chatId;

    try {
      chatId = int.parse(chatIdRaw);
    } catch (e) {
      const errorMessage = 'Query parameter chatId is invalid';
      throw const ApiException.badRequest(errorMessage);
    }

    final ChatModel model = await database.unpinChat(
      chatId: chatId,
      userId: user.id,
    );

    return Response.ok(jsonEncode(model.toJson()));
  }
}
