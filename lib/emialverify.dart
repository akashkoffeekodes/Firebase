import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';


class Email extends StatefulWidget {
  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> {
  /// The boolean to handle the dynamic operations
  bool submitValid = false;

  /// Text editing controllers to get the value from text fields
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _otpcontroller = TextEditingController();

  // Declare the object
  EmailAuth emailAuth;

  @override
  void initState() {
    super.initState();
    // Initialize the package
    emailAuth = new EmailAuth(
      sessionName: "Sample session",
    );

    /// Configuring the remote server
    Map<String, String> remoteServerConfiguration;

    emailAuth.config(remoteServerConfiguration);

  }

  /// a void function to verify if the Data provided is true
  /// Convert it into a boolean function to match your needs.
  void verify() {
    print(emailAuth.validateOtp(
        recipientMail: _emailcontroller.value.text,
        userOtp: _otpcontroller.value.text));
  }

  /// a void funtion to send the OTP to the user
  /// Can also be converted into a Boolean function and render accordingly for providers
  void sendOtp() async {
    bool result = await emailAuth.sendOtp(
        recipientMail: _emailcontroller.value.text, otpLength: 5);
    if (result) {
      setState(() {
        submitValid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return
       Scaffold(


        appBar: AppBar(
          title: const Text('Email Auth sample'),
        ),
        body: Container(
          margin: EdgeInsets.all(5),
          child: Center(
              child: Center(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _emailcontroller,
                    ),
                    Card(
                      margin: EdgeInsets.only(top: 20),
                      elevation: 6,
                      child: Container(
                        height: 50,
                        width: 200,
                        color: Colors.teal,
                        child: GestureDetector(
                          onTap: sendOtp,
                          child: Center(
                            child: Text(
                              "Request OTP",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// A dynamically rendering text field
                    (submitValid)
                        ? TextField(
                      controller: _otpcontroller,
                    )
                        : Container(height: 1),
                    (submitValid)
                        ? Container(
                      margin: EdgeInsets.only(top: 20),
                      height: 50,
                      width: 200,
                      color: Colors.teal,
                      child: GestureDetector(
                        onTap: verify,
                        child: Center(
                          child: Text(
                            "Verify",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    )
                        : SizedBox(height: 1)
                  ],
                ),
              )),
        ),
      );

  }
}