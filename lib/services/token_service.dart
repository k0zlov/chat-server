import 'package:chat_server/utils/jwt_client.dart';

/// Interface for a token service.
abstract interface class TokenService {
  /// Generates an access token for the specified user ID.
  String generateAccessToken(int userId);

  /// Generates a refresh token for the specified user ID.
  String generateRefreshToken(int userId);

  /// Validates the provided access token.
  bool validateAccessToken(String token);

  /// Validates the provided refresh token.
  bool validateRefreshToken(String token);

  /// Retrieves the user ID from the provided access token.
  int? getUserIdFromAccessToken(String token);

  /// Retrieves the user ID from the provided refresh token.
  int? getUserIdFromRefreshToken(String token);
}

/// Implementation of [TokenService] using JWT.
class TokenServiceImpl implements TokenService {
  /// Creates an instance of [TokenServiceImpl] with the required JWT clients.
  const TokenServiceImpl({
    required this.refreshClient,
    required this.accessClient,
  });

  /// The JWT client used for refresh tokens.
  final JwtClient refreshClient;

  /// The JWT client used for access tokens.
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
