import 'dart:convert';

import 'package:chat_server/database/database.dart';
import 'package:chat_server/exceptions/api_error.dart';
import 'package:chat_server/utils/request_validator.dart';
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
    const List<ValidatorParameter<String>> parameters = [
      ValidatorParameter(name: 'subject'),
      ValidatorParameter(name: 'content', nullable: true),
    ];

    final Map<String, dynamic> body = await RequestValidator.validateReqBody(
      request,
      requiredParams: parameters,
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
    final Map<String, String> queryParams = RequestValidator.validateReqParams(
      request,
      requiredParams: ['id'],
    );

    dynamic id = queryParams['id'];

    try {
      id = int.parse(id as String);
      id as int;
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
