import 'dart:io';

class ServerConfig {
  const ServerConfig({
    required this.ip,
    required this.port,
  });

  final InternetAddress ip;
  final int port;
}
