import 'package:chat_server/exceptions/api_exception.dart';
import 'package:shelf/shelf.dart';

/// The ContactsController interface defines the contract for managing user contacts.
///
/// It includes methods for retrieving all contacts, adding a new contact,
/// removing an existing contact, and searching for users to add as contacts.
abstract interface class ContactsController {
  /// Retrieves all contacts for the authenticated user.
  ///
  /// Returns a [Response] containing a list of contacts in JSON format.
  /// Throws [ApiException] if an error occurs during retrieval.
  Future<Response> getAll(Request request);

  /// Adds a new contact for the authenticated user.
  ///
  /// Accepts a [Request] containing the contactUserId in the request body.
  /// Returns a [Response] with the newly added contact in JSON format.
  /// Throws [ApiException] if the contact could not be added or if validation fails.
  Future<Response> add(Request request);

  /// Removes a contact for the authenticated user.
  ///
  /// Accepts a [Request] containing the contactUserId in the request body.
  /// Returns a [Response] indicating the result of the removal operation.
  /// Throws [ApiException] if the contact could not be removed or if validation fails.
  Future<Response> remove(Request request);

  /// Searches for users to add as contacts for the authenticated user.
  ///
  /// Accepts a [Request] containing the search query parameters.
  /// Returns a [Response] with the search results in JSON format.
  /// Throws [ApiException] if an error occurs during the search.
  Future<Response> search(Request request);
}
