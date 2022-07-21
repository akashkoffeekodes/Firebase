import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class Home_page_email extends StatefulWidget {
  const Home_page_email({Key key}) : super(key: key);

  @override
  State<Home_page_email> createState() => _Home_page_emailState();
}

class _Home_page_emailState extends State<Home_page_email> {
  bool isemailverify = false;
  Timer timer;

  verify_email() {
    isemailverify = FirebaseAuth.instance.currentUser.emailVerified;

    if (!isemailverify) {
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please create a account')));
      Send_verification_link();
      timer = Timer.periodic(Duration(seconds: 5), (_) => check_email_verify());
    }
  }

  check_email_verify() {
    FirebaseAuth.instance.currentUser.reload();
    isemailverify = FirebaseAuth.instance.currentUser.emailVerified;
    if (isemailverify) timer.cancel();
  }

  Send_verification_link() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user.sendEmailVerification();
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          SizedBox(
            height: 100,
          ),
          Center(
            child: Text("welcome Please verify your email adderss"),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
              child: Text("Logout")),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () async {
                check_email_verify();
                Send_verification_link();
              },
              child: Text("click to send link"))
        ]),
      ),
    );
  }
}
