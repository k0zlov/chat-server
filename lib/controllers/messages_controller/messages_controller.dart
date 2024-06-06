import 'package:shelf/shelf.dart';

/// The [MessagesController] abstract interface class defines the contract
/// for handling message-related operations such as sending, deleting,
/// and updating messages.
///
/// Classes that implement this interface must provide concrete implementations
/// for these methods.
abstract interface class MessagesController {
  /// Sends a message.
  ///
  /// This method takes a [Request] object, processes it to extract the
  /// necessary information for sending a message, and returns a [Response]
  /// object indicating the result of the operation.
  ///
  /// - Parameter request: The request object containing message data.
  /// - Returns: A [Response] object indicating the result of the send operation.
  Future<Response> send(Request request);

  /// Deletes a message.
  ///
  /// This method takes a [Request] object, processes it to extract the
  /// necessary information for deleting a message, and returns a [Response]
  /// object indicating the result of the operation.
  ///
  /// - Parameter request: The request object containing the message ID.
  /// - Returns: A [Response] object indicating the result of the delete operation.
  Future<Response> delete(Request request);

  /// Updates a message.
  ///
  /// This method takes a [Request] object, processes it to extract the
  /// necessary information for updating a message, and returns a [Response]
  /// object indicating the result of the operation.
  ///
  /// - Parameter request: The request object containing the updated message data.
  /// - Returns: A [Response] object indicating the result of the update operation.
  Future<Response> update(Request request);
}