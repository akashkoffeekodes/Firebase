
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/mobile_otp/emialverify.dart';
import 'package:firebase/fetch.dart';
import 'package:firebase/loginhome.dart';
import 'package:firebase/mobile_otp/loginmobile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


class AddDetail extends StatefulWidget {
  String id;
  String name;
  String contact;


  AddDetail({this.id, this.name, this.contact, Key key}) : super(key: key);

  @override
  _AddDetailState createState() => _AddDetailState();
}

class _AddDetailState extends State<AddDetail> {
  TextEditingController id = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController contact = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.id != null) {
      name.text = widget.name;
      contact.text = widget.contact;
      id.text = widget.id;
    }
    //uid = FirebaseAuth.instance.currentUser.uid;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Exmple"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset("assets/koffefode logo.png"),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                cursorHeight: 20,
                autofocus: false,
                controller: id,
                decoration: InputDecoration(
                  labelText: 'Enter your ID',
                  hintText: "Enter your Id",
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.teal, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    gapPadding: 0.0,
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.tealAccent, width: 1.5),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                cursorHeight: 20,
                autofocus: false,
                controller: name,
                decoration: InputDecoration(
                  labelText: 'Enter your Name',
                  hintText: "Enter your name",
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.teal, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    gapPadding: 0.0,
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.tealAccent, width: 1.5),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                cursorHeight: 20,
                autofocus: false,
                controller: contact,
                decoration: InputDecoration(
                  labelText: 'Enter your Mobile',
                  hintText: "Enter your mobile",
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.teal, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    gapPadding: 0.0,
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.tealAccent, width: 1.5),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    createUser(
                        id: id.text, contact: contact.text, name: name.text);
                    updateUser(
                        id: id.text, name: name.text, contact: contact.text);

                    // Navigator.pop(context);
                  },
                  child: Text("SUBMIT")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Fetchdata()),
                    );
                  },
                  child: Text("Listdata")),

              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: Text("Login reg...")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text("mobile verify")),

              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Email()),
                    );
                  },
                  child: Text("Email verify")),





            ],
          ),
        ),
      ),
    );
  }

  Future createUser({String id, String name, String contact}) async {
    final docUser = FirebaseFirestore.instance.collection("User").doc();
    final data = {'name': name, 'id': id, 'contact': contact};
    await docUser.set(data);
  }

  Future updateUser({String id, String name, String contact}) async {
    final updatedata = {
      'id': id,
      'name': name,
      'contact': contact,
    };
    FirebaseFirestore.instance.collection('User').doc(
        //data.docs[index].id
        widget.id).update(updatedata);

    // await docUser.set(updatedata );
  }

}
