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

      try {
        authHeader as String;

        accessToken = authHeader.split(' ')[1];

        final int? userId = tokenService.getUserIdFromAccessToken(accessToken);

        if (userId == null) throw Exception();

        final modifiedRequest = request.change(
          context: {'userId': userId},
        );

        return await innerHandler(modifiedRequest);
      } catch (e) {
        throw const ApiException.unauthorized();
      }
    };
  };
}
