import 'dart:async';
import 'package:chat_server/exceptions/api_exception.dart';
import 'package:shelf/shelf.dart';

/// The AuthController interface defines the contract for user authentication and management.
///
/// It includes methods for user registration, login, logout, activation, token refresh,
/// and retrieving user details.
abstract interface class AuthController {
  /// Retrieves the authenticated user's details.
  ///
  /// Returns a [Response] containing the user's details in JSON format.
  /// Throws [ApiException] if the user is not found or if an error occurs during retrieval.
  Future<Response> getUser(Request request);

  /// Registers a new user.
  ///
  /// Accepts a [Request] containing the registration details (name, email, password) in the request body.
  /// Returns a [Response] with the access token and refresh token in JSON format.
  /// Throws [ApiException] if the registration fails or if a user with the same email already exists.
  Future<Response> register(Request request);

  /// Logs in a user.
  ///
  /// Accepts a [Request] containing the login credentials (email, password) in the request body.
  /// Returns a [Response] with the access token and refresh token in JSON format.
  /// Throws [ApiException] if the login fails due to incorrect credentials or other errors.
  Future<Response> login(Request request);

  /// Logs out the authenticated user.
  ///
  /// Returns a [Response] indicating the result of the logout operation.
  /// Throws [ApiException] if the logout fails.
  Future<Response> logout(Request request);

  /// Activates a user's account using an activation link.
  ///
  /// Accepts a [Request] and an activation ID.
  /// Returns a [Response] indicating the result of the activation operation.
  /// Throws [ApiException] if the activation fails or if the activation link is invalid.
  Future<Response> activation(Request request, String id);

  /// Refreshes the user's access token using a refresh token.
  ///
  /// Returns a [Response] with the new access token and refresh token in JSON format.
  /// Throws [ApiException] if the refresh token is invalid or if the refresh operation fails.
  Future<Response> refresh(Request request);

  /// Updates the authenticated user's details.
  ///
  /// Returns a [Response] containing the user's details in JSON format.
  /// Throws [ApiException] if the operation fails.
  Future<Response> update(Request request);
}
