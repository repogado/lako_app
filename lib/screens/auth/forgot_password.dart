import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lako_app/widgets/dialogs/info_dialog.dart';
import 'package:lako_app/widgets/dialogs/loading_dialog.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/form_validations.dart';
import '../../widgets/buttons/def_button.dart';
import '../../widgets/textfields/auth_textfield.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:encrypt/encrypt.dart' as Enc;

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailTextController = TextEditingController();

  late AuthProvider _authProvider;
  final _formKey = GlobalKey<FormState>();

  void sendEmail() async {
    // showLoaderDialog(context);

    // String username = 'lakoapptech@gmail.com';
    // String password = 'cqfujuqinccmtkab';

    // final smtpServer = gmailSaslXoauth2(username, password);

    // final message = Message()
    //   ..from = Address(username, 'Your name')
    //   ..recipients.add('reygabriellepogado@gmail.com')
    //   ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
    //   ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    //   ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    // try {
    //   final sendReport = await send(message, smtpServer);

    //   print('Message sent: ' + sendReport.toString());
    // } on MailerException catch (e) {
    //   print('Message not sent.');
    //   print(e.toString());
    //   for (var p in e.problems) {
    //     print('Problem: ${p.code}: ${p.msg}');
    //   }
    // }
    // Navigator.pop(context);

    const GMAIL_SCHEMA = 'com.google.android.gm';

    final bool gmailinstalled =
        await FlutterMailer.isAppInstalled(GMAIL_SCHEMA);

    if (gmailinstalled) {
      final MailOptions mailOptions = MailOptions(
        body: 'a long body for the email <br> with a subset of HTML',
        subject: 'the Email Subject',
        recipients: ['reygabriellepogado@gmail.com'],
        isHTML: true,
        bccRecipients: ['other@example.com'],
        ccRecipients: ['third@example.com'],
      );

      await FlutterMailer.send(mailOptions);
    } else {
      print('not installed');
    }
  }

  void sendEmailJS(String email) async {
    showLoaderDialog(context);
    final plainText = email;
    final key = Enc.Key.fromUtf8('ASDFGHJKLASDFGHJ');

    final encrypter = Enc.Encrypter(Enc.AES(
      key,
      mode: Enc.AESMode.cbc,
      padding: 'PKCS7',
    ));

    final iv = Enc.IV.fromUtf8('ASDFGHJKLASDFGHJ');

    final encrypted = encrypter.encrypt(email, iv: iv);

    Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    const serviceId = "service_ekednhs";
    const templateId = "template_4lx12nu";
    const publicKey = "vVUmmkM4CK0fW8Y8R";

    Map params = {
      "service_id": serviceId,
      "template_id": templateId,
      "user_id": publicKey,
      "accessToken": "wVpx6Q4QV02tjVzZHZepS",
      "template_params": {
        "subject": 'Lako Forgot Password',
        "message":
            '<a href=https://lako-app-web.netlify.app/reset-password?key=${encrypted.base64}>Change My Password</a>',
        "reply_to": "reygabriellepogado@gmail.com",
        "to": email
      },
    };
    try {
      final response = await dio
          .post("https://api.emailjs.com/api/v1.0/email/send", data: params);
    Navigator.pop(context);

      showInfoDialog(context, "Email Sent",
          "Please check your email sent at ${_emailTextController.text} to reset password");
      _emailTextController.text = "";
    } catch (e) {
    Navigator.pop(context);

      showInfoDialog(
          context, "Email Not Sent", "Something Went wrong sending email");
      if (e is DioError) {
        //handle DioError here by error type or by error code
        print(e.message);
        print(e.error);
      } else {
        print(e);
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AuthTextField(
                  textEditingController: _emailTextController,
                  title: "Email",
                  validator: (value) {
                    return Validations().emailValidator(value);
                  },
                ),
                SizedBox(height: 20),
                DefButton(
                  onPress: () async {
                    // sendEmail();

                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();

                      sendEmailJS(_emailTextController.text);
                    }
                  },
                  title: 'SUBMIT',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
