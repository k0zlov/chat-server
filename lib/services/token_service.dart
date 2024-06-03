import 'package:chat_server/utils/jwt_client.dart';

abstract interface class TokenService {
  String generateAccessToken(int userId);

  String generateRefreshToken(int userId);

  bool validateAccessToken(String token);

  bool validateRefreshToken(String token);

  int? getUserIdFromAccessToken(String token);

  int? getUserIdFromRefreshToken(String token);
}

class TokenServiceImpl implements TokenService {
  const TokenServiceImpl({
    required this.refreshClient,
    required this.accessClient,
  });

  final JwtClient refreshClient;
  final JwtClient accessClient;

  @override
  String generateAccessToken(int userId) {
    return accessClient.generateToken(userId);
  }

  @override
  String generateRefreshToken(int userId) {
    return refreshClient.generateToken(userId);
  }

  @override
  bool validateAccessToken(String token) {
    return accessClient.validateToken(token);
  }

  @override
  bool validateRefreshToken(String token) {
    return refreshClient.validateToken(token);
  }

  @override
  int? getUserIdFromAccessToken(String token) {
    return accessClient.getUserIdFromToken(token);
  }

  @override
  int? getUserIdFromRefreshToken(String token) {
    return refreshClient.getUserIdFromToken(token);
  }
}
