import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

/// A client for generating and validating JWT tokens.
class JwtClient {
  /// Constructs a [JwtClient] with a given [secretKey] and [expiresIn] duration.
  const JwtClient({
    required this.secretKey,
    required this.expiresIn,
  });

  /// The secret key used to sign and verify JWT tokens.
  final SecretKey secretKey;

  /// The duration for which the token will be valid.
  final Duration expiresIn;

  /// Generates the payload with the user ID and expiration time.
  ///
  /// Takes the user ID and the expiration time in seconds since epoch as parameters.
  Map<String, dynamic> _generatePayload({
    required int userId,
    required int expiresIn,
  }) {
    return {
      'userId': userId,
      'exp': expiresIn,
    };
  }

  /// Generates a JWT token for the given user ID.
  ///
  /// Returns the signed token as a [String].
  String generateToken(int userId) {
    final DateTime expiringDate = DateTime.now().add(expiresIn);
    final int exp = expiringDate.millisecondsSinceEpoch ~/ 1000;

    final Map<String, dynamic> payload = _generatePayload(
      userId: userId,
      expiresIn: exp,
    );

    final jwt = JWT(payload);
    final String token = jwt.sign(secretKey);

    return token;
  }

  /// Returns userId from token or null if token is not valid
  int? getUserIdFromToken(String token) {
    final bool isValid = validateToken(token);

    if (!isValid) return null;

    try {
      final jwt = JWT.decode(token);

      final Map<String, dynamic> payload = jwt.payload as Map<String, dynamic>;

      final userId = payload['userId'] as int;
      return userId;
    } catch (e) {
      return null;
    }
  }

  /// Validates the given JWT token.
  ///
  /// Returns `true` if the token is valid, otherwise `false`.
  bool validateToken(String token) {
    try {
      JWT.verify(token, secretKey);

      return true;
    } catch (e) {
      return false;
    }
  }
}
