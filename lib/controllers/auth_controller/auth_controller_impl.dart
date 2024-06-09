import 'dart:async';
import 'dart:convert';

import 'package:chat_server/controllers/auth_controller/auth_controller.dart';
import 'package:chat_server/database/database.dart';
import 'package:chat_server/database/extensions/users_extension.dart';
import 'package:chat_server/exceptions/api_exception.dart';
import 'package:chat_server/services/mail_service.dart';
import 'package:chat_server/services/token_service.dart';
import 'package:chat_server/tables/users.dart';
import 'package:chat_server/utils/cookie.dart';
import 'package:chat_server/utils/request_validator.dart';
import 'package:drift/drift.dart';
import 'package:shelf/shelf.dart';
import 'package:uuid/v4.dart';

/// Implementation of [AuthController] for managing user authentication.
class AuthControllerImpl implements AuthController {
  /// Creates an instance of [AuthControllerImpl] with the required [database], [tokenService], and [mailService].
  const AuthControllerImpl({
    required this.database,
    required this.tokenService,
    required this.mailService,
  });

  /// The database instance used for querying and modifying user data.
  final Database database;

  /// The service used for generating and validating tokens.
  final TokenService tokenService;

  /// The service used for sending emails.
  final MailService mailService;

  @override
  Future<Response> getUser(Request request) async {
    final User? user;

    try {
      user = request.context['user']! as User?;
    } catch (e) {
      throw const ApiException.unauthorized();
    }

    if (user == null) {
      const errorMessage = 'User with such id was not found';
      throw const ApiException.unauthorized(errorMessage);
    }

    return Response.ok(jsonEncode(user.toResponse()));
  }

  @override
  Future<Response> activation(Request request, String activation) async {
    try {
      await database.activateUser(activation: activation);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const ApiException.internalServerError(
        'There was an error while activating user',
      );
    }

    return Response.ok(jsonEncode('Successfully activated'));
  }

  @override
  Future<Response> login(Request request) async {
    final Map<String, dynamic> body = RequestValidator.getBodyFromContext(
      request,
    );

    final String email = body['email'] as String;
    final String password = body['password'] as String;

    final User? user = await database.getUserFromEmail(email: email);

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
      'accessToken': accessToken,
      'refreshToken': refreshToken,
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
      'accessToken': accessToken,
      'refreshToken': refreshToken,
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

    final String activation = const UuidV4().generate();

    String? accessToken;
    String? refreshToken;

    try {
      await database.transaction<void>(() async {
        final User user = await database.users.insertReturning(
          UsersCompanion.insert(
            name: name,
            password: password,
            email: email,
            refreshToken: '',
            activation: activation,
          ),
        );

        accessToken = tokenService.generateAccessToken(user.id);

        refreshToken = tokenService.generateRefreshToken(user.id);

        final User newUser = user.copyWith(
          refreshToken: refreshToken,
          activation: activation,
        );

        await database.users.update().replace(newUser);
      });
    } catch (e) {
      throw const ApiException.internalServerError(
        'Could not register user',
      );
    }

    if (accessToken == null || refreshToken == null) {
      throw const ApiException.internalServerError(
        'Could not generate tokens',
      );
    }

    unawaited(
      mailService.sendActivationLetter(
        email: email,
        activationId: activation,
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
    final User user = request.context['user']! as User;

    if (user.refreshToken.isEmpty) {
      return Response.ok(jsonEncode('User has already been logged out'));
    }

    final User newUser = user.copyWith(refreshToken: '');

    final bool result = await database.users.update().replace(newUser);

    if (!result) {
      const errorMessage = 'Could not log out user';
      throw const ApiException.internalServerError(errorMessage);
    }

    return Response.ok(jsonEncode('Successfully logged out'));
  }

  @override
  Future<Response> update(Request request) async {
    final User user = request.context['user']! as User;

    final Map<String, dynamic> body = RequestValidator.getBodyFromContext(
      request,
    );

    final String? name = body['name'] as String?;
    final String? bio = body['bio'] as String?;

    final User updatedUser;
    try {
      updatedUser = await database.updateUser(
        user: user,
        bio: bio ?? user.bio,
        name: name ?? user.name,
      );
    } catch (e) {
      throw const ApiException.internalServerError(
        'Could not update user data',
      );
    }

    return Response.ok(jsonEncode(updatedUser.toResponse()));
  }
}
