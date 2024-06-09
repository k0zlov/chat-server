import 'package:chat_server/database/database.dart';
import 'package:chat_server/tables/messages.dart';

/// Model class to hold message information, including author name.
class MessageModel {
  /// Basic constructor of [MessageModel]
  const MessageModel({
    required this.message,
    required this.user,
  });

  /// The message information.
  final Message message;

  /// The user information.
  final User user;

  /// Converts the [MessageModel] instance to a map for JSON response.
  Map<String, dynamic> toJson() {
    return {
      ...message.toResponse(),
      'authorName': user.name,
    };
  }
}
