import 'package:shelf/shelf.dart';

abstract interface class MiddlewareHandler {
  Middleware call();
}
