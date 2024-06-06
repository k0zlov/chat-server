import 'package:chat_server/exceptions/api_exception.dart';
import 'package:drift/drift.dart';
import 'package:shelf/shelf.dart';

/// Middleware for handling errors in request processing.
Middleware errorMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      try {
        // Process the request with the inner handler.
        return await innerHandler(request);
      } on ApiException catch (e) {
        // Handle custom API exceptions and return the appropriate response.
        print(e);
        return e.toResponse();
      } on InvalidDataException catch (e) {
        // Handle database-related exceptions and return an internal server error response.
        print(e);
        const ApiException exception = ApiException.internalServerError(
          'Error while communicating with database.',
        );
        return exception.toResponse();
      } catch (e) {
        // Handle any other exceptions and return a generic internal server error response.
        print(e);
        const ApiException exception = ApiException.internalServerError(
          'An error occurred.',
        );
        return exception.toResponse();
      }
    };
  };
}
