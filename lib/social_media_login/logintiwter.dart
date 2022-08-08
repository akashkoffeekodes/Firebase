import 'package:flutter/material.dart';
import 'package:twitter_login/twitter_login.dart';


class Twitwer extends StatefulWidget {
  const Twitwer({Key key}) : super(key: key);

  @override
  _TwitwerState createState() => _TwitwerState();
}

class _TwitwerState extends State<Twitwer> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Login with twitter'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: TextButton(
                child: Text('login'),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                  minimumSize: MaterialStateProperty.all<Size>(Size(160, 48)),
                ),
                onPressed: () async {
                  await login();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future login() async {
    final twitterLogin = TwitterLogin(
        apiKey: "gmuScWZFIzvvmA3Jwuana9PtD",
        apiSecretKey: "klDlweoqpraSfuGSDnbPdBaxE0BzrNlzUiNFhxJ1pRPwDFO0vp",
        redirectURI: "flutter-twitter-login://",
    );
    final authResult = await twitterLogin.login();
    switch (authResult.status) {
      case TwitterLoginStatus.loggedIn:
        print("success");
        break;
      case TwitterLoginStatus.cancelledByUser:
      // cancel
        break;
      case TwitterLoginStatus.error:
      // error
        break;
    }
  }

}
