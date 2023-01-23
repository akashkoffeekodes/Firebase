import 'package:firebase/social_media_login/loginwithfacebook.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool isloggedin = false;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("start");
      }
    });
  }

  getUser() async {
    User firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isloggedin = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();

    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: !isloggedin
              ? CircularProgressIndicator()
              : Column(
            children: <Widget>[
              SizedBox(height: 40.0),
              Container(
                height: 300,
                child: Image(
                  image: AssetImage("assets/koffefode logo.png"),
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Image.network("${user.photoURL}",height: 200,width: 400,),
                      Text(
                        "Hello ${user.displayName}\n you are Logged in as \n ${user.email}",
                        style:
                        TextStyle(fontSize: 20.0, ),
                      ),

                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                child: ElevatedButton(
                  onPressed: signOut,
                  child: Text('Signout',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),



              ))],
          ),
        ));
  }
}
