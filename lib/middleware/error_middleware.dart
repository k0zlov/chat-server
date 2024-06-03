import 'package:chat_server/exceptions/api_error.dart';
import 'package:chat_server/middleware/middleware_handler.dart';
import 'package:shelf/shelf.dart';

class ErrorMiddleware implements MiddlewareHandler {
  @override
  Middleware call() {
    return (Handler innerHandler) {
      return (Request request) async {
        try {
          return await innerHandler(request);
        } on ApiException catch (e) {
          return e.toResponse();
        } catch (e) {
          const ApiException exception = ApiException.internalServerError(
            'An error occurred.',
          );
          return exception.toResponse();
        }
      };
    };
  }
}
