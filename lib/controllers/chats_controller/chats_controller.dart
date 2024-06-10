import 'package:chat_server/exceptions/api_exception.dart';
import 'package:shelf/shelf.dart';

/// The ChatsController interface defines the contract for managing chat operations.
///
/// It includes methods for retrieving all chats, creating, deleting, updating chats,
/// and joining, leaving, and searching for chats.
abstract interface class ChatsController {
  /// Retrieves all chats for the authenticated user.
  ///
  /// This method should handle the request to fetch all chat instances associated
  /// with the authenticated user. The response should be formatted in JSON.
  ///
  /// Returns a [Response] containing a list of chats in JSON format.
  /// Throws [ApiException] if an error occurs during retrieval.
  Future<Response> getAll(Request request);

  /// Creates a new chat.
  ///
  /// This method should handle the creation of a new chat based on the details
  /// provided in the request body. The response should include the newly created chat in JSON format.
  ///
  /// Accepts a [Request] containing the chat details in the request body.
  /// Returns a [Response] with the newly created chat in JSON format.
  /// Throws [ApiException] if the chat could not be created or if validation fails.
  Future<Response> create(Request request);

  /// Deletes a chat.
  ///
  /// This method should handle the deletion of a chat specified by the chat ID
  /// provided as a query parameter. The response should indicate the result of the deletion operation.
  ///
  /// Accepts a [Request] containing the chat ID as a query parameter.
  /// Returns a [Response] indicating the result of the deletion operation.
  /// Throws [ApiException] if the chat could not be deleted or if validation fails.
  Future<Response> delete(Request request);

  /// Updates a chat.
  ///
  /// This method should handle the update of a chat based on the details provided
  /// in the request body. The response should include the updated chat in JSON format.
  ///
  /// Accepts a [Request] containing the chat details in the request body.
  /// Returns a [Response] with the updated chat in JSON format.
  /// Throws [ApiException] if the chat could not be updated or if validation fails.
  Future<Response> update(Request request);

  /// Adds the authenticated user to a chat.
  ///
  /// This method should handle the operation of adding the authenticated user to
  /// a specified chat, identified by the chat ID in the request body. The response should include the chat model.
  ///
  /// Accepts a [Request] containing the chat ID in the request body.
  /// Returns a [Response] with the chat model.
  /// Throws [ApiException] if the user could not join the chat or if validation fails.
  Future<Response> join(Request request);

  /// Removes the authenticated user from a chat.
  ///
  /// This method should handle the operation of removing the authenticated user
  /// from a specified chat, identified by the chat ID in the request body. The response should indicate the result of the leave operation.
  ///
  /// Accepts a [Request] containing the chat ID in the request body.
  /// Returns a [Response] indicating the result of the leave operation.
  /// Throws [ApiException] if the user could not leave the chat or if validation fails.
  Future<Response> leave(Request request);

  /// Searches for chats by title.
  ///
  /// This method should handle the search operation for chats based on the provided
  /// search query parameters. The response should include the search results in JSON format.
  ///
  /// Accepts a [Request] containing the search query parameters.
  /// Returns a [Response] with the search results in JSON format.
  /// Throws [ApiException] if an error occurs during the search.
  Future<Response> search(Request request);

  /// Updates a participant's details in a chat.
  ///
  /// This method should handle updating a participant's details within a chat
  /// based on the provided request body. The response should include the updated participant details.
  ///
  /// Accepts a [Request] containing the participant details in the request body.
  /// Returns a [Response] with the updated participant details.
  /// Throws [ApiException] if the participant details could not be updated or if validation fails.
  Future<Response> updateParticipant(Request request);

  /// Pins a chat for the authenticated user.
  ///
  /// This method should handle pinning a specified chat for the authenticated user,
  /// identified by the chat ID in the request body. The response should confirm the pinning action.
  ///
  /// Accepts a [Request] containing the chat ID in the request body.
  /// Returns a [Response] confirming the pinning action.
  /// Throws [ApiException] if the chat could not be pinned or if validation fails.
  Future<Response> pinChat(Request request);

  /// Unpins a chat for the authenticated user.
  ///
  /// This method should handle unpinning a specified chat for the authenticated user,
  /// identified by the chat ID in the request body. The response should confirm the unpinning action.
  ///
  /// Accepts a [Request] containing the chat ID in the request body.
  /// Returns a [Response] confirming the unpinning action.
  /// Throws [ApiException] if the chat could not be unpinned or if validation fails.
  Future<Response> unpinChat(Request request);

  /// Archives a chat for the authenticated user.
  ///
  /// This method should handle archiving a specified chat for the authenticated user,
  /// identified by the chat ID in the request body. The response should confirm the archiving action.
  ///
  /// Accepts a [Request] containing the chat ID in the request body.
  /// Returns a [Response] confirming the archiving action.
  /// Throws [ApiException] if the chat could not be archived or if validation fails.
  Future<Response> archiveChat(Request request);

  /// Unarchives a chat for the authenticated user.
  ///
  /// This method should handle unarchiving a specified chat for the authenticated user,
  /// identified by the chat ID in the request body. The response should confirm the unarchiving action.
  ///
  /// Accepts a [Request] containing the chat ID in the request body.
  /// Returns a [Response] confirming the unarchiving action.
  /// Throws [ApiException] if the chat could not be unarchived or if validation fails.
  Future<Response> unarchiveChat(Request request);
}
