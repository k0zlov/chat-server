import 'dart:async';
import 'dart:convert';

import 'package:chat_server/database/database.dart';
import 'package:chat_server/exceptions/api_error.dart';
import 'package:chat_server/services/mail_service.dart';
import 'package:chat_server/services/token_service.dart';
import 'package:chat_server/utils/cookie.dart';
import 'package:chat_server/utils/request_validator.dart';
import 'package:drift/drift.dart';
import 'package:shelf/shelf.dart';
import 'package:uuid/v4.dart';

abstract interface class AuthController {
  Future<Response> getUser(Request request);

  Future<Response> register(Request request);

  Future<Response> login(Request request);

  Future<Response> logout(Request request);

  Future<Response> activation(Request request, String id);

  Future<Response> refresh(Request request);
}

class AuthControllerImpl implements AuthController {
  const AuthControllerImpl({
    required this.database,
    required this.tokenService,
    required this.mailService,
  });

  final Database database;
  final TokenService tokenService;
  final MailService mailService;

  @override
  Future<Response> getUser(Request request) async {
    final int userId = request.context['userId']! as int;

    final User? user = await (database.users.select()
          ..where((tbl) => tbl.id.equals(userId)))
        .getSingleOrNull();

    if (user == null) {
      const errorMessage = 'User with such id was not found';
      throw const ApiException.unauthorized(errorMessage);
    }

    final Map<String, dynamic> response = {
      ...user.toJson(),
      'createdAt': user.createdAt.dateTime.toIso8601String(),
    };

    return Response.ok(jsonEncode(response));
  }

  @override
  Future<Response> activation(Request request, String activation) async {
    final User? user = await (database.users.select()
          ..where((tbl) => tbl.activation.equals(activation)))
        .getSingleOrNull();

    if (user == null) {
      const errorMessage = 'There is no user with such activation link';
      throw const ApiException.badRequest(errorMessage);
    }

    if (user.isActivated) {
      return Response.ok('Already activated');
    }

    final User newUser = user.copyWith(isActivated: true);

    final bool result = await database.users.update().replace(newUser);

    if (!result) {
      const errorMessage = 'Could not activate user';
      throw const ApiException.internalServerError(errorMessage);
    }

    return Response.ok('Successfully activated');
  }

  @override
  Future<Response> login(Request request) async {
    final Map<String, dynamic> body = RequestValidator.getBodyFromContext(
      request,
    );

    final String email = body['email'] as String;
    final String password = body['password'] as String;

    final User? user = await (database.users.select()
          ..where((tbl) => tbl.email.equals(email)))
        .getSingleOrNull();

    if (user == null) {
      const errorMessage = 'There is no user with such email';
      throw const ApiException.badRequest(errorMessage);
    }

    if (user.password != password) {
      const errorMessage = 'Wrong password';
      throw const ApiException.badRequest(errorMessage);
    }

    final String refreshToken = tokenService.generateRefreshToken(user.id);
    final String accessToken = tokenService.generateAccessToken(user.id);

    final User newUser = user.copyWith(refreshToken: refreshToken);

    final bool result = await database.users.update().replace(newUser);

    if (!result) {
      const errorMessage = 'Could not refresh tokens';
      throw const ApiException.internalServerError(errorMessage);
    }

    unawaited(mailService.sendInformationLetter(email: email));

    final Map<String, String> response = {
      'refreshToken': refreshToken,
      'accessToken': accessToken,
    };

    return Response.ok(jsonEncode(response));
  }

  @override
  Future<Response> refresh(Request request) async {
    final String? token = extractCookie(request, 'refreshToken');

    if (token == null) {
      const errorMessage = 'RefreshToken missing';
      throw const ApiException.unauthorized(errorMessage);
    }

    if (!tokenService.validateRefreshToken(token)) {
      const errorMessage = 'Refresh token is not valid';
      throw const ApiException.unauthorized(errorMessage);
    }

    final User? user = await (database.users.select()
          ..where((tbl) => tbl.refreshToken.equals(token)))
        .getSingleOrNull();

    if (user == null) {
      const errorMessage = 'Owner of refresh token was not found';
      throw const ApiException.unauthorized(errorMessage);
    }

    final String refreshToken = tokenService.generateRefreshToken(user.id);
    final String accessToken = tokenService.generateAccessToken(user.id);

    final User newUser = user.copyWith(refreshToken: refreshToken);

    await database.users.update().replace(newUser);

    final Map<String, dynamic> responseBody = {
      'refreshToken': refreshToken,
      'accessToken': accessToken,
    };

    return Response.ok(jsonEncode(responseBody));
  }

  @override
  Future<Response> register(Request request) async {
    final Map<String, dynamic> body = RequestValidator.getBodyFromContext(
      request,
    );

    final String name = body['name'] as String;
    final String email = body['email'] as String;
    final String password = body['password'] as String;

    final int count = await database.users
        .count(where: (tbl) => tbl.email.equals(email))
        .getSingle();

    if (count > 0) {
      const errorMessage = 'User with such email already exists';
      throw const ApiException.badRequest(errorMessage);
    }

    final User user = await database.users.insertReturning(
      UsersCompanion(
        name: Value(name),
        password: Value(password),
        email: Value(email),
        refreshToken: const Value(''),
        activation: const Value(''),
      ),
    );

    final String accessToken = tokenService.generateAccessToken(user.id);

    final String refreshToken = tokenService.generateRefreshToken(user.id);

    final String activation = const UuidV4().generate();

    final User newUser = user.copyWith(
      refreshToken: refreshToken,
      activation: activation,
    );

    await database.users.update().replace(newUser);

    unawaited(
      mailService.sendActivationLetter(
        email: email,
        activationId: newUser.activation,
      ),
    );

    final Map<String, dynamic> response = {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };

    return Response.ok(jsonEncode(response));
  }

  @override
  Future<Response> logout(Request request) async {
    final int userId = request.context['userId']! as int;

    final User? user = await (database.users.select()
          ..where((tbl) => tbl.id.equals(userId)))
        .getSingleOrNull();

    if (user == null) {
      const errorMessage = 'Could not find user with such id';
      throw const ApiException.unauthorized(errorMessage);
    }

    if (user.refreshToken.isEmpty) {
      return Response.ok('User has already been logged out');
    }

    final User newUser = user.copyWith(refreshToken: '');

    final bool result = await database.users.update().replace(newUser);

    if (!result) {
      const errorMessage = 'Could not log out user';
      throw const ApiException.internalServerError(errorMessage);
    }

    return Response.ok('Successfully logged out');
  }
}
