import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase/Model/productmodel.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProductDetailPage extends StatefulWidget {
  ProductDetailPage({Key? key,required this.type,required this.name,required this.amount,required this.quantity,required this.images}) : super(key: key);

  int type,amount,quantity;
  String name;
  List images;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {

  int activeIndex = 0;

  List<T> map<T>(int list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list; i++) {
      result.add(handler(i, list));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Product Detail",
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context,"Refresh");
          },
          child: const Icon(
            Icons.chevron_left_sharp,
            color: Colors.white,
            size: 30,
          ),
        ),
        centerTitle: true,
        elevation: 0
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowGlow();
          return true;
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              CarouselSlider.builder(
                options: CarouselOptions(
                  aspectRatio: 16/9,
                  viewportFraction: 1,
                  enableInfiniteScroll: true,
                  initialPage: 0,
                  reverse: false,
                  autoPlay: true,
                  // autoPlayInterval: Duration(milliseconds: 7000),
                  onPageChanged: (index, reason) =>
                    setState(() => activeIndex = index
                  )
                ),
                itemCount: widget.images.length,
                itemBuilder: (context, itemIndex, realIndex) {
                  return Hero(
                    tag: widget.name,
                    child:
                    widget.type == 0
                      ?
                    CachedNetworkImage(
                      fit: BoxFit.contain,
                      imageUrl: widget.images[itemIndex],
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.blue)),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    )
                      :
                    Image.file(
                      File(widget.images[itemIndex]),
                      fit: BoxFit.fill,
                    ),
                  );
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: map<Widget>(widget.images.length, (index, url) {
                  return Container(
                    width: activeIndex == index ? 20 : 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.black
                      ),
                      color: activeIndex == index ? Colors.black : Colors.transparent,
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  const Text(
                    "Name: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 18
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  const Text(
                    "Amount: ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                  Text(
                    widget.amount.toString(),
                    style: const TextStyle(
                        fontSize: 18
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  const Text(
                    "Quantity: ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                  Text(
                    widget.quantity.toString(),
                    style: const TextStyle(
                        fontSize: 18
                    ),
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
