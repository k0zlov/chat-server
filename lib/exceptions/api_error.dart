import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

class ApiException implements Exception {
  const ApiException(
    this.errorMessage, {
    required this.statusCode,
  });

  const ApiException.badRequest(this.errorMessage)
      : statusCode = HttpStatus.badRequest;

  const ApiException.unauthorized(this.errorMessage)
      : statusCode = HttpStatus.unauthorized;

  const ApiException.internalServerError(this.errorMessage)
      : statusCode = HttpStatus.internalServerError;

  const ApiException.notFound()
      : statusCode = HttpStatus.notFound,
        errorMessage = 'Resource was not found';

  final int statusCode;
  final String errorMessage;

  Response toResponse() {
    final Map<String, dynamic> body = toMap();

    return Response(statusCode, body: jsonEncode(body));
  }

  Map<String, dynamic> toMap() {
    return {
      'errorMessage': errorMessage,
    };
  }

  @override
  String toString() {
    return 'ApiException{statusCode: $statusCode, errorMessage: $errorMessage}';
  }
}
