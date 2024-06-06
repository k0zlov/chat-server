import 'package:shelf/shelf.dart';

/// Middleware for adding custom headers to responses.
Middleware headersMiddleware(Map<String, String> headers) {
  return createMiddleware(
    responseHandler: (response) {
      // Merge the custom headers with the existing response headers.
      return response.change(
        headers: {
          ...headers,
          ...response.headersAll,
        },
      );
    },
  );
}
