import 'dart:async';

import 'package:chat_server/database/database.dart';
import 'package:chat_server/database/extensions/users_extension.dart';
import 'package:chat_server/exceptions/api_exception.dart';
import 'package:chat_server/services/token_service.dart';
import 'package:shelf/shelf.dart';

/// Middleware for handling authentication by verifying access tokens.
Middleware authMiddleware({
  required TokenService tokenService,
  required Database database,
}) {
  return (Handler innerHandler) {
    return (Request request) async {
      // Retrieve the headers from the request.
      final Map<String, String> headers = request.headers;

      // Extract the Authorization header.
      final dynamic authHeader = headers['Authorization'];

      // Variables to store the access token and user ID.
      final String accessToken;
      final User? user;

      try {
        // Ensure the Authorization header is a string.
        authHeader as String;

        // Extract the access token from the Authorization header.
        accessToken = authHeader.split(' ')[1];

        // Retrieve the user ID from the access token.
        final int userId = tokenService.getUserIdFromAccessToken(accessToken)!;

        // Retrieve the user from database by userId
        user = await database.getUserFromId(userId: userId);
        if (user == null) throw Exception();

        unawaited(
          database.updateLastActivity(user: user),
        );
      } catch (e) {
        // Throw an unauthorized exception if any error occurs.
        throw const ApiException.unauthorized();
      }

      // Create a new request with the user added to the context.
      final newRequest = request.change(
        context: {
          'user': user,
          ...request.context,
        },
      );

      // Call the inner handler with the new request.
      return await innerHandler(newRequest);
    };
  };
}
