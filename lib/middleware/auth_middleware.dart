import 'package:chat_server/exceptions/api_error.dart';
import 'package:chat_server/services/token_service.dart';
import 'package:shelf/shelf.dart';

Middleware authMiddleware({
  required TokenService tokenService,
}) {
  return (Handler innerHandler) {
    return (Request request) async {
      final Map<String, String> headers = request.headers;

      final dynamic authHeader = headers['Authorization'];

      final String accessToken;

      final int userId;

      try {
        authHeader as String;

        accessToken = authHeader.split(' ')[1];

        userId = tokenService.getUserIdFromAccessToken(accessToken)!;
      } catch (e) {
        throw const ApiException.unauthorized();
      }

      final newRequest = request.change(
        context: {
          'userId': userId,
          ...request.context,
        },
      );

      return await innerHandler(newRequest);
    };
  };
}
