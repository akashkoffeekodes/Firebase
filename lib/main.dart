import 'package:firebase/detail.dart';
import 'package:firebase/login.dart';
import 'package:firebase/mobile_otp/loginmobile.dart';
import 'package:firebase/start.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


import 'email_verify_link/sendSignInLinkToEmail.dart';
import 'signup.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Example',
      theme: ThemeData(


        primarySwatch: Colors.teal,
      ),
      home:  LoginScreen(),

      // routes: <String,WidgetBuilder>{
      //
      //   "Login" : (BuildContext context)=>Login(),
      //   "SignUp":(BuildContext context)=>SignUp(),
      //   "start":(BuildContext context)=>Start(),
      // },

    );
  }
}

