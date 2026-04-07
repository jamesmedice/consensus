import 'package:flutter_email_sender/flutter_email_sender.dart';

Future<void> sendConsensusEmail(String maleEmail, String femaleEmail, String data, String subject) async {
  final email = Email(body: data, subject: subject, recipients: [maleEmail], cc: [femaleEmail], isHTML: false);
  await FlutterEmailSender.send(email);
}
