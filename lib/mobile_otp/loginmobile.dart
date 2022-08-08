import 'dart:async';

import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:firebase/mobile_otp/mobilehome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:pinput/pin_put/pin_put.dart';
import 'package:pinput/pinput.dart';
import '../detail.dart';



class LoginScreen extends StatefulWidget {

  final Duration timerTastoPremuto;

  const LoginScreen({Key key, this.timerTastoPremuto}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _commingSms ;
  TextEditingController _controller = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode;
  TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  // final BoxDecoration pinPutDecoration = BoxDecoration(
  //   color: Colors.tealAccent,
  //   borderRadius: BorderRadius.circular(10.0),
  //   border: Border.all(
  //     color: const Color.fromRGBO(126, 203, 224, 1),
  //   ),
  // );

  final PinTheme defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color:Colors.black ),
      borderRadius: BorderRadius.circular(20),
    ),
  );



  Future<void> initSmsListener() async {
    String commingSms;
    try {
      commingSms = await AltSmsAutofill().listenForSms;
    } on PlatformException {
      commingSms = 'Failed to get Sms.';
    }
    if (!mounted) return;

    setState(() {
      _commingSms = commingSms;
      if(_commingSms != null || _commingSms != "" ){
        _pinPutController.text = _commingSms.substring(0,6);
      }

    });
  }


  @override
  void dispose() {
   AltSmsAutofill().unregisterListener();
    _timer.cancel();
    super.dispose();
  }

  final _maxSeconds = 61;
  int _currentSecond = 0;
  Timer _timer;

  String get _timerText {
    final secondsPerMinute = 60;
    final secondsLeft = _maxSeconds - _currentSecond;

    final formattedMinutesLeft =
    (secondsLeft ~/ secondsPerMinute).toString().padLeft(2, '0');
    final formattedSecondsLeft =
    (secondsLeft % secondsPerMinute).toString().padLeft(2, '0');

    print('$formattedMinutesLeft : $formattedSecondsLeft');
    return '$formattedMinutesLeft : $formattedSecondsLeft';
  }

  void _startTimer() {
    final duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (Timer timer) {
      setState(() {
        _currentSecond = timer.tick;
        if (timer.tick >= _maxSeconds) timer.cancel();
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text('Phone Auth'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            Container(
              margin: EdgeInsets.only(top: 60),
              child: Center(
                child: Text(
                  'Phone Authentication',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40, right: 10, left: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  prefix: Padding(
                    padding: EdgeInsets.all(4),
                    child: Text('+91'),
                  ),
                ),
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: _controller,
              ),
            ),
            SizedBox(height: 50,),
            Text(_timerText,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child:/* PinPut(
                fieldsCount: 6,
                textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
                eachFieldWidth: 40.0,
                eachFieldHeight: 55.0,
                focusNode: _pinPutFocusNode,
                controller: _pinPutController,
                submittedFieldDecoration: pinPutDecoration,
                selectedFieldDecoration: pinPutDecoration,
                followingFieldDecoration: pinPutDecoration,
               // pinAnimationType: PinAnimationType.fade,
                onSubmit: (pin) async {
                  try {
                    await FirebaseAuth.instance
                        .signInWithCredential(PhoneAuthProvider.credential(
                        verificationId: _verificationCode, smsCode: pin))
                        .then((value) async {
                      if (value.user != null) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                                (route) => false);
                      }
                    });
                  } catch (e) {
                    FocusScope.of(context).unfocus();
                    _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text('invalid OTP')));
                  }
                },
              ),*/
              Pinput(
                length: 6,
                androidSmsAutofillMethod:  AndroidSmsAutofillMethod.smsRetrieverApi,
                focusNode: _pinPutFocusNode,
                controller: _pinPutController,
                defaultPinTheme: defaultPinTheme,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                onCompleted: (pin) => print(pin),
                validator: (pin) {
                  try {
                     FirebaseAuth.instance
                        .signInWithCredential(PhoneAuthProvider.credential(
                        verificationId: _verificationCode, smsCode: pin))
                        .then((value) async {
                      if (value.user != null) {
                        print("sucessfull");
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                                (route) => false);
                      }
                    });
                  } catch (e) {
                    print("Invalid otp");
                    FocusScope.of(context).unfocus();
                    _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text('invalid OTP')));
                  }
                },

                // onSubmitted: (pin) async {
                //   try {
                //     await FirebaseAuth.instance
                //         .signInWithCredential(PhoneAuthProvider.credential(
                //         verificationId: _verificationCode, smsCode: pin))
                //         .then((value) async {
                //       if (value.user != null) {
                //         Navigator.pushAndRemoveUntil(
                //             context,
                //             MaterialPageRoute(builder: (context) => Home()),
                //                 (route) => false);
                //       }
                //     });
                //   } catch (e) {
                //     FocusScope.of(context).unfocus();
                //     _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text('invalid OTP')));
                //   }
                // },

              )
            ),

            // Center(
            //   child: Text("$_commingSms"),
            // ),




          ]),
          Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            child: FlatButton(
              color: Colors.teal,
              onPressed: () {
                _startTimer();
               initSmsListener();
                _verifyPhone();
              },
              child: Text(
                'Next',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91 ${_controller.text}',

        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {

              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => Home()),
              //         (route) => false);
            }
          }).catchError((error) {});
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 60    ));
  }



}