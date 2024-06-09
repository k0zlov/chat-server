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
