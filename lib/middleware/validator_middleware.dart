import 'package:chat_server/utils/request_validator.dart';
import 'package:shelf/shelf.dart';

/// Middleware for validating request parameters and body parameters.
Middleware validatorMiddleware({
  List<ValidatorParameter<Object>> bodyParams = const [],
  List<String> requestParams = const [],
}) {
  assert(
    bodyParams.isNotEmpty || requestParams.isNotEmpty,
    'At least one of request or body params must be provided in validator middleware',
  );

  return (Handler innerHandler) {
    return (Request request) async {
      Map<String, dynamic>? body;

      // Validate request body parameters if provided.
      if (bodyParams.isNotEmpty) {
        body = await RequestValidator.validateReqBody(
          request,
          requiredParams: bodyParams,
        );
      }

      // Validate request query parameters if provided.
      if (requestParams.isNotEmpty) {
        RequestValidator.validateReqParams(
          request,
          requiredParams: requestParams,
        );
      }

      // Create a new request with the validated body added to the context if available.
      final Request newRequest = request.change(
        context: {
          ...request.context,
          if (body != null) 'body': body,
        },
      );

      // Call the inner handler with the new request.
      return await innerHandler(newRequest);
    };
  };
}
