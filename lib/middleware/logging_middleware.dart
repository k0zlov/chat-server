import 'package:chat_server/middleware/middleware_handler.dart';
import 'package:shelf/shelf.dart';

class LoggingMiddleware implements MiddlewareHandler {
  @override
  Middleware call() => logRequests();
}
