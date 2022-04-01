import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/detail.dart';
import 'package:flutter/material.dart';

class Fetchdata extends StatefulWidget {
  const Fetchdata({Key key}) : super(key: key);

  @override
  _FetchdataState createState() => _FetchdataState();
}

class _FetchdataState extends State<Fetchdata> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of data"),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('User').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            String docId;

            final data = snapshot.requireData;
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    return Card(
                      shadowColor: Colors.tealAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  // print(data.docs[index].id);

                                  Text("id:${data.docs[index]['id']}"),
                                  Text("name:${data.docs[index]['name']}"),
                                  Text(
                                      "contact:${data.docs[index]['contact']}"),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              iconSize: 24.0,
                              color: Colors.tealAccent,
                              onPressed: () async {
                                // print(data.docs[index].id);
                                try {
                                  FirebaseFirestore.instance
                                      .collection("User")
                                      .doc(data.docs[index].id)
                                      .delete()
                                      .then((_) {
                                    print("Sucess");
                                  });
                                } catch (e) {
                                  print("Error during delete");
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              iconSize: 24.0,
                              color: Colors.tealAccent,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddDetail(
                                              id: data.docs[index].id,
                                              name: data.docs[index]['name'],
                                          contact: data.docs[index]['contact'],


                                            )));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          },
        ),
      ),
    );
  }
}
