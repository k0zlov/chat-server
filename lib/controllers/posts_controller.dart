import 'dart:convert';

import 'package:chat_server/database/database.dart';
import 'package:chat_server/exceptions/api_error.dart';
import 'package:drift/drift.dart';
import 'package:shelf/shelf.dart';

abstract interface class PostsController {
  Future<Response> root(Request request);

  Future<Response> addPost(Request request);

  Future<Response> removePost(Request request);
}

class PostsControllerImpl implements PostsController {
  const PostsControllerImpl({
    required this.database,
  });

  final Database database;

  @override
  Future<Response> root(Request request) async {
    try {
      final List<Post> posts = await database.posts.all().get();

      final List<Map<String, dynamic>> jsonPosts = [];

      for (final Post post in posts) {
        jsonPosts.add(post.toJson());
      }

      return Response.ok(jsonEncode(posts));
    } catch (e) {
      const String errorMessage = 'Could not receive data from database';

      throw const ApiException.internalServerError(errorMessage);
    }
  }

  @override
  Future<Response> addPost(Request request) async {
    final dynamic payload;

    try {
      final String json = await request.readAsString();
      payload = jsonDecode(json);
      payload as Map<String, dynamic>;
    } catch (e) {
      const String errorMessage = 'Invalid request body.';

      throw const ApiException.badRequest(errorMessage);
    }

    final dynamic subject = payload['subject'];
    final dynamic content = payload['content'];

    if (subject == null || subject is! String) {
      const String errorMessage = 'Parameter subject was not provided.';

      throw const ApiException.badRequest(errorMessage);
    }

    try {
      final Post? post = await database.posts.insertReturningOrNull(
        PostsCompanion(
          subject: Value(subject),
          content: content is String ? Value(content) : const Value(''),
        ),
      );

      if (post == null) throw Exception();

      return Response.ok(jsonEncode(post.toJson()));
    } catch (e) {
      const String errorMessage = 'Could not insert post into database.';
      throw const ApiException.internalServerError(errorMessage);
    }
  }

  @override
  Future<Response> removePost(Request request) async {
    final Map<String, String> queryParams = request.url.queryParameters;

    dynamic id = queryParams['id'];

    try {
      id as String;
      id = int.parse(id);
      id as int;
    } catch(e) {
      const String errorMessage = 'Query parameter id was not provided.';
      throw const ApiException.badRequest(errorMessage);
    }

    try {
      final bool result = await database.posts.deleteOne(
        PostsCompanion(id: Value(id)),
      );

      if (result) {
        return Response.ok('Successfully deleted post.');
      } else {
        throw Exception();
      }
    } catch (e) {
      const String errorMessage = 'Could not remove post from database.';
      throw const ApiException.internalServerError(errorMessage);
    }
  }
}
