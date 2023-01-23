import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase/Model/productmodel.dart';
import 'package:firebase/UI/addimagespage.dart';
import 'package:firebase/UI/productdetailpage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FirbaseListing extends StatefulWidget {
  const FirbaseListing({Key? key}) : super(key: key);

  @override
  State<FirbaseListing> createState() => _FirbaseListingState();
}

class _FirbaseListingState extends State<FirbaseListing> {

  ConnectivityResult? result;

  @override
  void initState() {
    super.initState();

    Connectivity().onConnectivityChanged.listen((event) {

      if(event != ConnectivityResult.none) {
        print("CONNECTED!!!");
      } else {
        print("NOT CONNECTED!!!!");
      }

    }).onData((data) {

      setState(() {
        result = data;
      });
      check();

    });

  }

  check() async {

    if(result != ConnectivityResult.none) {
      upload();
    } else {
      print("DATA NOT UPLOADED!!!!");
    }

  }

  upload() async {

    FirebaseStorage storage = FirebaseStorage.instance;

    List<Product> products = Hive.box<Product>('products').values.toList().cast<Product>();

    if(products.isNotEmpty) {
      for(int i = 0; i < products.length; i++) {

        List sendingList = [];

        Product product = products[i];

        for(int i = 0; i < product.images.length; i++) {

          String path = "";

          DateTime date = DateTime.now();
          File imageFile = File(product.images[i]);

          await storage.ref("$date.jpg").putFile(imageFile).then((value) async {
            path = await storage.ref("$date.jpg").getDownloadURL();
          });

          sendingList.add(path);

        }

        FirebaseFirestore.instance.collection('PRODUCT').doc().set(
            {
              'date' : DateTime.now(),
              'name' : product.name,
              'amount' : product.amount,
              'quantity' : product.quantity,
              'images' : sendingList
            }
        ).then((value) {

          deleteTransaction(product);

        });

      }
    }

  }

  @override
  void dispose() {
    Hive.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Firebase Listing",
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var value = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddImagesPage()));

          if(value != null) {
            check();
          }

        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowGlow();
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [

              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('PRODUCT').orderBy('date').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                  if(!snapshot.hasData) {
                    return const SizedBox();
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {

                      final product = snapshot.data!.docs[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailPage(type: 0,name: product["name"],amount: product["amount"],quantity: product["quantity"],images: product["images"]))),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 5,
                                    spreadRadius: 2
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Name : ${product["name"]}",
                                      ),
                                      const SizedBox(height: 10,),
                                      Text(
                                        "Amount : ${product["amount"]}",
                                      ),
                                      const SizedBox(height: 10,),
                                      Text(
                                        "Quantity : ${product["quantity"]}",
                                      ),
                                      const SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () async {

                                          await  FirebaseFirestore.instance
                                              .collection("PRODUCT")
                                              .doc(product.id)
                                              .delete();

                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.circular(6)
                                          ),
                                          child: const Text(
                                            "Delete",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Hero(
                                    tag: product["name"],
                                    child: CachedNetworkImage(
                                      fit: BoxFit.contain,
                                      imageUrl: product["images"][0],
                                      width: 100,
                                      height: 100,
                                      placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.blue)),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );

                }
              ),

              ValueListenableBuilder<Box<Product>>(
                valueListenable: Boxes.getProducts().listenable(),
                builder: (context, box, _) {
                  final products = box.values.toList().cast<Product>();

                  return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      final product = products[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: GestureDetector(
                          onTap: () async {

                            var value = await Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailPage(type: 1,name: product.name,amount: product.amount,quantity: product.quantity,images: product.images)));

                            if(value != null) {
                              // check();
                            }

                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 5,
                                  spreadRadius: 2
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Name : ${product.name}",
                                      ),
                                      const SizedBox(height: 10,),
                                      Text(
                                        "Amount : ${product.amount}",
                                      ),
                                      const SizedBox(height: 10,),
                                      Text(
                                        "Quantity : ${product.quantity}",
                                      ),
                                      const SizedBox(height: 10,),
                                      GestureDetector(
                                        onTap: () => deleteTransaction(product),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(6)
                                          ),
                                          child: const Text(
                                            "Delete",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Hero(
                                  tag: product.name,
                                  child: Image.file(File(product.images[0]),height: 100,width: 100)
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  void deleteTransaction(Product product) {

    product.delete();

  }

}
