import 'dart:io';
import 'package:firebase/Model/productmodel.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class AddImagesPage extends StatefulWidget {
  const AddImagesPage({Key? key}) : super(key: key);

  @override
  State<AddImagesPage> createState() => _AddImagesPageState();
}

class _AddImagesPageState extends State<AddImagesPage> {

  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  final _picker = ImagePicker();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  List<XFile> photoList = [];

  List sendingList = [];

  getImages() async {

    sendingList = [];

    photoList = await _picker.pickMultiImage(
      maxWidth: MediaQuery.of(context).size.width,
      maxHeight: MediaQuery.of(context).size.height,
      imageQuality: 100,
    );

    for(var value in photoList) {
      setState(() {
        sendingList.add(value.path);
      });
    }

    if(photoList.length>6) {
      final snackBar =
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        content: Text("Only 6 Images Picked!",style:TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold)),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left_sharp,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Text(
          "Add Data",
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  addProduct(
                      nameController.text.trim(),
                      amountController.text.trim(),
                      quantityController.text.trim(),
                      sendingList
                  );
                  Navigator.pop(context,"Referesh");
                }
              },
              child: Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowGlow();
            return true;
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  photoList.length == 1
                      ?
                  Center(
                    child: SizedBox(
                      height: 300,
                      width: 300,
                      child: Image.file(File(sendingList[0])),
                    ),
                  )
                      :
                  StaggeredGridView.countBuilder(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    shrinkWrap: true,
                    itemCount: sendingList.length > 6 ? 6 : sendingList.length,
                    staggeredTileBuilder: (index) {
                      return StaggeredTile.fit(1);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Image.file(File(sendingList[index]))
                      );
                    },
                  ),

                  GestureDetector(
                    onTap: () => getImages(),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black
                        ),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Center(
                        child: Text(
                          "Add Images",
                          style: TextStyle(
                            fontSize: 20
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  Text(
                    "Add Name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),

                  SizedBox(height: 5),

                  TextFormField(
                    controller: nameController,
                    style: TextStyle(
                        fontSize: 14
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Name',
                    ),
                    validator: (String? value) {
                      if(value!.isEmpty)
                      {
                        return "Please enter Name";
                      }
                      return null;
                    }
                  ),

                  SizedBox(height: 30),

                  Text(
                    "Add Amount",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),

                  SizedBox(height: 5),

                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        fontSize: 14
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Amount',
                    ),
                    validator: (String? value) {
                      if(value!.isEmpty)
                      {
                        return "Please enter Amount";
                      }
                      return null;
                    }
                  ),

                  SizedBox(height: 30),

                  Text(
                    "Add Quantity",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),

                  SizedBox(height: 5),

                  TextFormField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        fontSize: 14
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Quantity',
                    ),
                    validator: (String? value) {
                      if(value!.isEmpty)
                      {
                        return "Please enter Quantity";
                      }
                      return null;
                    }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future addProduct(String name, String amount, String quantity, List images) async {
    final product = Product()
      ..name = name
      ..amount = int.parse(amount)
      ..quantity = int.parse(quantity)
      ..images = images;

    final box = Boxes.getProducts();
    box.add(product);

  }

}

class Boxes {

  static Box<Product> getProducts() =>
    Hive.box<Product>('products');

}