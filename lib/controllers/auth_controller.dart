import 'dart:convert';

import 'package:chat_server/database/database.dart';
import 'package:chat_server/exceptions/api_error.dart';
import 'package:chat_server/services/token_service.dart';
import 'package:chat_server/utils/cookie.dart';
import 'package:chat_server/utils/request_validator.dart';
import 'package:drift/drift.dart';
import 'package:shelf/shelf.dart';

abstract interface class AuthController {
  Future<Response> root(Request request);

  Future<Response> register(Request request);

  Future<Response> login(Request request);

  Future<Response> activation(Request request);

  Future<Response> refresh(Request request);
}

class AuthControllerImpl implements AuthController {
  const AuthControllerImpl({
    required this.database,
    required this.tokenService,
  });

  final Database database;
  final TokenService tokenService;

  @override
  Future<Response> root(Request request) async {
    // TODO: implement root
    throw UnimplementedError();
  }

  @override
  Future<Response> activation(Request request) async {
    // TODO: implement activation
    throw UnimplementedError();
  }

  @override
  Future<Response> login(Request request) async {
    // TODO: implement login
    throw UnimplementedError();
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
          ..where((tbl) => tbl.refreshtoken.equals(token)))
        .getSingleOrNull();

    if (user == null) {
      const errorMessage = 'Owner of refresh token was not found';
      throw const ApiException.unauthorized(errorMessage);
    }

    final String refreshToken = tokenService.generateRefreshToken(user.id);
    final String accessToken = tokenService.generateAccessToken(user.id);

    final User newUser = user.copyWith(refreshtoken: refreshToken);

    await (database.users.update()..where((tbl) => tbl.id.equals(user.id)))
        .write(newUser);

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
      const errorMessage = 'User with such email already exists.';
      throw const ApiException.badRequest(errorMessage);
    }

    final User user = await database.users.insertReturning(
      UsersCompanion(
        name: Value(name),
        password: Value(password),
        email: Value(email),
        refreshtoken: const Value(''),
        activationLink: const Value(''),
      ),
    );
    final String accessToken = tokenService.generateAccessToken(user.id);

    final String refreshToken = tokenService.generateRefreshToken(user.id);

    final User newUser = user.copyWith(refreshtoken: refreshToken);

    await (database.users.update()..where((tbl) => tbl.id.equals(user.id)))
        .write(newUser);

    final Map<String, dynamic> response = {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };

    return Response.ok(jsonEncode(response));
  }
}
