import 'package:shelf/shelf.dart';

Middleware headersMiddleware(Map<String, String> headers) {
  return createMiddleware(
    responseHandler: (response) {
      return response.change(
        headers: {
          ...headers,
          ...response.headersAll,
        },
      );
    },
  );
}
