import 'dart:convert';

import 'package:chat_server/exceptions/api_exception.dart';
import 'package:shelf/shelf.dart';

/// A parameter validator that ensures the presence and type of parameters in requests.
class ValidatorParameter<T> {
  /// Creates a [ValidatorParameter] with the specified [name] and nullability.
  const ValidatorParameter({
    required this.name,
    this.nullable = false,
  });

  /// The name of the parameter to validate.
  final String name;

  /// Indicates if the parameter can be null.
  final bool nullable;

  /// Checks if the parameter value is valid.
  void _check(dynamic value) {
    if (value == null && nullable) return;
    value as T;
  }
}

/// A utility class for validating request bodies and query parameters.
class RequestValidator {
  /// Private constructor to prevent instantiation.
  const RequestValidator._();

  /// Validates the request body against the required parameters.
  static Future<Map<String, dynamic>> validateReqBody(
      Request request, {
        required List<ValidatorParameter<Object>> requiredParams,
      }) async {
    final dynamic payload;

    try {
      // Read and decode the request body.
      final String json = await request.readAsString();
      payload = jsonDecode(json);
      payload as Map<String, dynamic>;
    } catch (e) {
      // Throw an error if the request body is invalid.
      const String errorMessage = 'Invalid request body.';
      throw const ApiException.badRequest(errorMessage);
    }

    // Check each required parameter in the payload.
    for (final parameter in requiredParams) {
      final dynamic value = payload[parameter.name];

      // Check if the parameter is missing and not nullable.
      if (value == null && !parameter.nullable) {
        final errorMessage = 'The parameter ${parameter.name} was not provided';
        throw ApiException.badRequest(errorMessage);
      }

      // Check if the parameter has an invalid type.
      try {
        parameter._check(value);
      } catch (e) {
        final errorMessage =
            'The parameter ${parameter.name} has an invalid type.';
        throw ApiException.badRequest(errorMessage);
      }
    }

    return payload;
  }

  /// Validates the query parameters against the required parameters.
  static Map<String, String> validateReqParams(
      Request request, {
        required List<String> requiredParams,
      }) {
    final Map<String, String> queryParams = request.url.queryParameters;

    // Check each required query parameter.
    for (final String parameter in requiredParams) {
      if (!queryParams.containsKey(parameter)) {
        final errorMessage = 'The query parameter $parameter was not provided.';
        throw ApiException.badRequest(errorMessage);
      }
    }

    return queryParams;
  }

  /// Retrieves the request body from the context.
  static Map<String, dynamic> getBodyFromContext(Request request) {
    try {
      final body = request.context['body']! as Map<String, dynamic>;
      return body;
    } catch (e) {
      const errorMessage = 'Could not get request body from context';
      throw const ApiException.internalServerError(errorMessage);
    }
  }
}
