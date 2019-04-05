import 'package:flutter/material.dart';
import 'package:mailer2/mailer.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String attachment;

  final _recipientController = TextEditingController(
    text: 'example@example.com',
  );

  final _emailController = TextEditingController(
    text: 'sender@sender.com',
  );

  final _passwordController = TextEditingController(
    text: 'Sender\'s password',
  );

  final _subjectController = TextEditingController(text: 'The subject');

  final _bodyController = TextEditingController(
    text: 'Mail body.',
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  sendMail() {
    // If you want to use an arbitrary SMTP server, go with `new SmtpOptions()`.
    // This class below is just for convenience. There are more similar classes available.
    var options = new GmailSmtpOptions()
      ..username = _emailController.text
      ..password = _passwordController
          .text; // Note: if you have Google's "app specific passwords" enabled,
    // you need to use one of those here.

    // How you use and store passwords is up to you. Beware of storing passwords in plain.

    // Create our email transport.
    var emailTransport = new SmtpTransport(options);

    // Create our mail/envelope.
    var envelope = new Envelope()
      ..from = 'foo@bar.com'
      ..recipients.add(_recipientController.text)
      ..subject = _subjectController.text
      ..text = 'This is a cool email message. Whats up?'
      ..html = '<h1>Test</h1><p>${_bodyController.text}</p>';

    // Email it.
    emailTransport
        .send(envelope)
        .then((envelope) => setState(() {
              attachment = 'Email sent!';
            }))
        .catchError((e) => setState(() {
              attachment = 'Error occurred: $e';
            }));
  }

  @override
  Widget build(BuildContext context) {
    final Widget imagePath = Text(attachment ?? '');

    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.red),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Plugin example app'),
          actions: <Widget>[
            IconButton(
              onPressed: sendMail,
              icon: Icon(Icons.send),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _recipientController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Recipient',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _subjectController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Subject',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _bodyController,
                      maxLines: 10,
                      decoration: InputDecoration(
                          labelText: 'Body', border: OutlineInputBorder()),
                    ),
                  ),
                  imagePath,
                  Dialog(
                    child: Text('$attachment'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
