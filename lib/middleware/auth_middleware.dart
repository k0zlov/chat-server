import 'package:chat_server/exceptions/api_exception.dart';
import 'package:chat_server/services/token_service.dart';
import 'package:shelf/shelf.dart';

/// Middleware for handling authentication by verifying access tokens.
Middleware authMiddleware({
  required TokenService tokenService,
}) {
  return (Handler innerHandler) {
    return (Request request) async {
      // Retrieve the headers from the request.
      final Map<String, String> headers = request.headers;

      // Extract the Authorization header.
      final dynamic authHeader = headers['Authorization'];

      // Variables to store the access token and user ID.
      final String accessToken;
      final int userId;

      try {
        // Ensure the Authorization header is a string.
        authHeader as String;

        // Extract the access token from the Authorization header.
        accessToken = authHeader.split(' ')[1];

        // Retrieve the user ID from the access token.
        userId = tokenService.getUserIdFromAccessToken(accessToken)!;
      } catch (e) {
        // Throw an unauthorized exception if any error occurs.
        throw const ApiException.unauthorized();
      }

      // Create a new request with the user ID added to the context.
      final newRequest = request.change(
        context: {
          'userId': userId,
          ...request.context,
        },
      );

      // Call the inner handler with the new request.
      return await innerHandler(newRequest);
    };
  };
}
