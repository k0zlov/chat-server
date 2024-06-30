import 'package:chat_server/database/database.dart';
import 'package:chat_server/tables/contacts.dart';

/// A model for holding contact information along with user details.
class ContactModel {
  /// Constructs an instance of [ContactModel] with the given contact and user data.
  ///
  /// Parameters:
  ///   [contact] The [Contact] instance representing the contact details.
  ///   [user] The user data  of the contact.
  const ContactModel({
    required this.contact,
    required this.user,
  });

  /// The [Contact] instance representing the contact details.
  final Contact contact;

  /// The user data of the contact.
  final User user;

  /// Converts the [ContactModel] instance to a JSON-compatible map.
  ///
  /// Returns:
  ///   A map containing the serialized contact details.
  Map<String, dynamic> toJson() {
    return {
      ...contact.toResponse(),
      'name': user.name,
      'email': user.email,
      'bio': user.bio,
      'lastActivityAt': user.lastActivityAt.dateTime.toIso8601String(),
    };
  }
}
