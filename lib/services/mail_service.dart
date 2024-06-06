import 'package:aws_sesv2_api/sesv2-2019-09-27.dart';

/// Interface for a mail service.
abstract interface class MailService {
  /// Sends an activation letter to the specified email address with the given activation ID.
  Future<bool> sendActivationLetter({
    required String email,
    required String activationId,
  });

  /// Sends an informational letter to the specified email address.
  Future<bool> sendInformationLetter({
    required String email,
  });
}

/// Implementation of [MailService] using AWS SES.
class MailServiceImpl implements MailService {
  /// Creates an instance of [MailServiceImpl] with the required SES client, base URL, and email address.
  const MailServiceImpl({
    required this.sesClient,
    required this.baseUrl,
    required this.emailAddress,
  });

  /// The SES client used to send emails.
  final SESV2 sesClient;

  /// The base URL used in the activation link.
  final String baseUrl;

  /// The email address used as the sender.
  final String emailAddress;

  /// Sends an email with the specified subject and content to the specified email address.
  Future<bool> sendLetter({
    required String email,
    required String subject,
    required Body content,
  }) async {
    try {
      await sesClient.sendEmail(
        destination: Destination(toAddresses: [email]),
        fromEmailAddress: 'notification@$emailAddress',
        content: EmailContent(
          simple: Message(
            subject: Content(data: subject),
            body: content,
          ),
        ),
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> sendActivationLetter({
    required String email,
    required String activationId,
  }) {
    final String link = '$baseUrl/auth/activation/$activationId';
    final html = '<div><h1>Confirm Email</h1><a href="$link">$link</a></div>';

    return sendLetter(
      email: email,
      subject: 'Account activation letter from chat-server',
      content: Body(
        html: Content(data: html),
      ),
    );
  }

  @override
  Future<bool> sendInformationLetter({required String email}) async {
    const text =
        'System has detected a user currently working under your credentials!';

    return sendLetter(
      email: email,
      subject: 'Login notification from chat-server',
      content: Body(
        text: Content(data: text),
      ),
    );
  }
}
