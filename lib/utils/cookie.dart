import 'package:shelf/shelf.dart';

/// Extracts the value of the specified cookie from the request headers.
String? extractCookie(Request request, String cookieName) {
  // Retrieve the 'Cookie' header from the request headers.
  final cookies = request.headers['Cookie'];

  // Return null if no cookies are present.
  if (cookies == null) {
    return null;
  }

  // Split the cookies string into individual cookies.
  final cookieList = cookies.split(';');

  // Iterate through each cookie.
  for (final cookie in cookieList) {
    // Split each cookie into name and value parts.
    final cookieParts = cookie.split('=');

    // Ensure the cookie has both a name and a value.
    if (cookieParts.length == 2) {
      final name = cookieParts[0].trim();
      final value = cookieParts[1].trim();

      // Check if the cookie name matches the specified cookie name.
      if (name == cookieName) {
        return value;
      }
    }
  }

  // Return null if the specified cookie is not found.
  return null;
}
