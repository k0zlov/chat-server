import 'dart:convert';

import 'package:chat_server/database/database.dart';
import 'package:chat_server/exceptions/api_error.dart';
import 'package:chat_server/utils/request_validator.dart';
import 'package:drift/drift.dart';
import 'package:shelf/shelf.dart';

/// An abstract interface for handling post-related HTTP requests.
abstract interface class PostsController {
  /// Handles the root endpoint, typically returning a list of posts.
  Future<Response> getAll(Request request);

  /// Handles the addition of a new post.
  Future<Response> addPost(Request request);

  /// Handles the removal of an existing post.
  Future<Response> removePost(Request request);
}

/// Implementation of [PostsController] for managing posts.
class PostsControllerImpl implements PostsController {
  /// Creates an instance of [PostsControllerImpl] with the given [database].
  const PostsControllerImpl({
    required this.database,
  });

  /// Database instance for performing database actions.
  final Database database;

  @override
  Future<Response> getAll(Request request) async {
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
    final Map<String, dynamic> body = RequestValidator.getBodyFromContext(
      request,
    );

    final String subject = body['subject'] as String;
    final String? content = body['content'] as String?;

    try {
      final Post? post = await database.posts.insertReturningOrNull(
        PostsCompanion(
          subject: Value(subject),
          content: content != null ? Value(content) : const Value(''),
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

    final String rawId = queryParams['id']!;

    final int id;

    try {
      id = int.parse(rawId);
    } catch (e) {
      const String errorMessage = 'The Query parameter id has an invalid type.';
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
