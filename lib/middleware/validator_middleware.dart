import 'package:chat_server/utils/request_validator.dart';
import 'package:shelf/shelf.dart';

Middleware validatorMiddleware({
  List<ValidatorParameter<Object>> bodyParams = const [],
  List<String> requestParams = const [],
}) {
  assert(
    bodyParams.isNotEmpty || requestParams.isNotEmpty,
    'Any of request or body params were not provided in validator middleware',
  );

  return (Handler innerHandler) {
    return (Request request) async {
      Map<String, dynamic>? body;

      if (bodyParams.isNotEmpty) {
        body = await RequestValidator.validateReqBody(
          request,
          requiredParams: bodyParams,
        );
      }

      if (requestParams.isNotEmpty) {
        RequestValidator.validateReqParams(
          request,
          requiredParams: requestParams,
        );
      }

      final Request newRequest = request.change(
        context: {
          ...request.context,
          if (body != null) ...{
            'body': body,
          },
        },
      );

      return await innerHandler(newRequest);
    };
  };
}
