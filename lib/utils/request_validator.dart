import 'dart:convert';

import 'package:chat_server/exceptions/api_error.dart';
import 'package:shelf/shelf.dart';

class ValidatorParameter<T> {
  const ValidatorParameter({
    required this.name,
    this.nullable = false,
  });

  final String name;
  final bool nullable;

  void _check(dynamic value) {
    if (value == null && nullable) return;
    value as T;
  }
}

class RequestValidator {
  const RequestValidator._();

  static Future<Map<String, dynamic>> validateReqBody(
    Request request, {
    required List<ValidatorParameter<Object>> requiredParams,
  }) async {
    final dynamic payload;

    try {
      final String json = await request.readAsString();
      payload = jsonDecode(json);
      payload as Map<String, dynamic>;
    } catch (e) {
      const String errorMessage = 'Invalid request body.';

      throw const ApiException.badRequest(errorMessage);
    }

    for (final parameter in requiredParams) {
      final dynamic value = payload[parameter.name];

      if (value == null && !parameter.nullable) {
        final errorMessage = 'The Parameter ${parameter.name} was not provided';
        throw ApiException.badRequest(errorMessage);
      }

      try {
        parameter._check(value);
      } catch (e) {
        final errorMessage =
            'The Parameter ${parameter.name} has an invalid type.';
        throw ApiException.badRequest(errorMessage);
      }
    }

    return payload;
  }

  static Map<String, String> validateReqParams(
    Request request, {
    required List<String> requiredParams,
  }) {
    final Map<String, String> queryParams = request.url.queryParameters;

    for (final String parameter in requiredParams) {
      if (!queryParams.containsKey(parameter)) {
        final errorMessage = 'The query parameter $parameter was not provided.';
        throw ApiException.badRequest(errorMessage);
      }
    }

    return queryParams;
  }
}
