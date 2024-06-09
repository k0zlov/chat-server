import 'package:chat_server/exceptions/api_exception.dart';
import 'package:shelf/shelf.dart';

/// The ChatsController interface defines the contract for managing chat operations.
///
/// It includes methods for retrieving all chats, creating, deleting, updating chats,
/// and joining, leaving, and searching for chats.
abstract interface class ChatsController {
  /// Retrieves all chats for the authenticated user.
  ///
  /// Returns a [Response] containing a list of chats in JSON format.
  /// Throws [ApiException] if an error occurs during retrieval.
  Future<Response> getAll(Request request);

  /// Creates a new chat.
  ///
  /// Accepts a [Request] containing the chat details in the request body.
  /// Returns a [Response] with the newly created chat in JSON format.
  /// Throws [ApiException] if the chat could not be created or if validation fails.
  Future<Response> create(Request request);

  /// Deletes a chat.
  ///
  /// Accepts a [Request] containing the chat ID as a query parameter.
  /// Returns a [Response] indicating the result of the deletion operation.
  /// Throws [ApiException] if the chat could not be deleted or if validation fails.
  Future<Response> delete(Request request);

  /// Updates a chat.
  ///
  /// Accepts a [Request] containing the chat details in the request body.
  /// Returns a [Response] with the updated chat in JSON format.
  /// Throws [ApiException] if the chat could not be updated or if validation fails.
  Future<Response> update(Request request);

  /// Adds the authenticated user to a chat.
  ///
  /// Accepts a [Request] containing the chat ID in the request body.
  /// Returns a [Response] with chat model.
  /// Throws [ApiException] if the user could not join the chat or if validation fails.
  Future<Response> join(Request request);

  /// Removes the authenticated user from a chat.
  ///
  /// Accepts a [Request] containing the chat ID in the request body.
  /// Returns a [Response] indicating the result of the leave operation.
  /// Throws [ApiException] if the user could not leave the chat or if validation fails.
  Future<Response> leave(Request request);

  /// Searches for chats by title.
  ///
  /// Accepts a [Request] containing the search query parameters.
  /// Returns a [Response] with the search results in JSON format.
  /// Throws [ApiException] if an error occurs during the search.
  Future<Response> search(Request request);

  Future<Response> updateParticipant(Request request);

  Future<Response> pinChat(Request request);

  Future<Response> unpinChat(Request request);

  Future<Response> archiveChat(Request request);

  Future<Response> unarchiveChat(Request request);
}
