import 'package:shelf/shelf.dart';

String? extractCookie(Request request, String cookieName) {
  final cookies = request.headers['Cookie'];
  if (cookies == null) {
    return null;
  }

  final cookieList = cookies.split(';');
  for (final cookie in cookieList) {
    final cookieParts = cookie.split('=');
    if (cookieParts.length == 2) {
      final name = cookieParts[0].trim();
      final value = cookieParts[1].trim();
      if (name == cookieName) {
        return value;
      }
    }
  }

  return null;
}
