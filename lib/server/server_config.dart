import 'dart:io';

/// Configuration class for the server.
class ServerConfig {
  /// Creates an instance of [ServerConfig] with the specified IP address and port.
  const ServerConfig({
    required this.ip,
    required this.port,
  });

  /// The IP address the server will bind to.
  final InternetAddress ip;

  /// The port the server will listen on.
  final int port;
}
