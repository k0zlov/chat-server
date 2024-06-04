import 'package:aws_sesv2_api/sesv2-2019-09-27.dart';

abstract interface class MailService {
  Future<bool> sendActivationLetter({
    required String email,
    required String activationId,
  });

  Future<bool> sendInformationLetter({required String email});
}

class MailServiceImpl implements MailService {
  const MailServiceImpl({
    required this.sesClient,
    required this.baseUrl,
    required this.emailAddress,
  });

  final SESV2 sesClient;
  final String baseUrl;
  final String emailAddress;

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
      subject: 'Account activation letter from k0zlov/chat-app',
      content: Body(
        html: Content(
          data: html,
        ),
      ),
    );
  }

  @override
  Future<bool> sendInformationLetter({required String email}) async {
    const text =
        'System has detected a user currently working under you credentials!';

    return sendLetter(
      email: email,
      subject: 'Login notification from k0zlov/chat-app',
      content: Body(
        text: Content(
          data: text,
        ),
      ),
    );
  }
}
