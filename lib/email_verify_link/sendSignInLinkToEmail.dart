import 'dart:async';
import 'package:firebase/email_verify_link/homage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Verify_link extends StatefulWidget {
  const Verify_link({Key key}) : super(key: key);

  @override
  State<Verify_link> createState() => _Verify_linkState();
}

class _Verify_linkState extends State<Verify_link> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future Signup() async {
    // final isValid = formKey.curretState.validate();
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      //  UrlUtilsReadOnly.showSnackbar(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login_Email_link")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: 'Enter Email',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.red),
                    borderRadius: BorderRadius.circular(15),
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  labelText: 'Enter Password',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.red),
                    borderRadius: BorderRadius.circular(15),
                  )),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () async {
                  Signup().then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Home_page_email()),
                    );
                    setState((){
                      emailController.clear();
                      passwordController.clear();
                    });
                  });
                },
                child: Text("SUBMIT")),
            SizedBox(
              height: 20,
            ),

          ],
        ),
      ),
    );
  }
}
