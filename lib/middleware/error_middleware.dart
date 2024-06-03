import 'package:chat_server/exceptions/api_error.dart';
import 'package:drift/drift.dart';
import 'package:shelf/shelf.dart';

Middleware errorMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      try {
        return await innerHandler(request);
      } on ApiException catch (e) {
        return e.toResponse();
      } on InvalidDataException catch (e) {
        print(e);

        const ApiException exception = ApiException.internalServerError(
          'Error while communicating with database.',
        );
        return exception.toResponse();
      } catch (e) {
        print(e);
        const ApiException exception = ApiException.internalServerError(
          'An error occurred.',
        );
        return exception.toResponse();
      }
    };
  };
}
