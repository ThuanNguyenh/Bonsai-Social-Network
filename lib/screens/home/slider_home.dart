import 'dart:math';
import 'dart:core';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../products/product_detail.dart';

class SliderHome extends StatefulWidget {
  const SliderHome({Key? key}) : super(key: key);

  @override
  State<SliderHome> createState() => _SliderHomeState();
}

class _SliderHomeState extends State<SliderHome> {
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchFilter = TextEditingController();

  final bool loading = false;

  late MainProvider mainProvider;

  String formatTimeAgo(Duration difference) {
    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'ngày' : 'ngày'}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'giờ trước' : 'giờ trước'}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'phút trước' : 'phút trước'}';
    } else {
      return 'vừa xong';
    }
  }

  @override
  Widget build(BuildContext context) {
    mainProvider = Provider.of<MainProvider>(context);
    return StreamBuilder(
        stream: ref.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {


          if(snapshot.hasData && snapshot.data!.snapshot.value != null) {
            Map<dynamic, dynamic> map =
            snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            List<dynamic> list = [];
            list.clear();
            list = map.values.toList();

            // Sắp xếp theo thứ tự views giảm dần
            list.sort((a, b) => (b['views'] ?? 0).compareTo(a['views'] ?? 0));
            
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: min(6, snapshot.data!.snapshot.children.length),
                itemBuilder: (context, index) {

                  Map<dynamic, dynamic> productData = list[index];

                  // Calculate timeAgo here
                  String timeAgo = formatTimeAgo(
                      DateTime.now().difference(
                          DateTime.fromMillisecondsSinceEpoch(
                              productData['createdAt'])));

                  Provider.of<MainProvider>(context, listen: false).saveProduct(productData, timeAgo);

                  return buildProductContainer(productData, mainProvider, timeAgo);

                  // return buildProductContainer(list[index]);
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }


        }
    );
  }

  Widget buildProductContainer(Map<dynamic, dynamic> productData, mainProvider, String timeAgo) {
    // Get the timestamp from Firebase
    int createdAtTimestamp = productData['createdAt'];

    // Calculate the time difference
    DateTime createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtTimestamp);
    DateTime now = DateTime.now();
    Duration difference = now.difference(createdAt);

    // Format the time difference
    String timeAgo = formatTimeAgo(difference);

    return InkWell(
      onTap: () {
        mainProvider.setSelectedProduct(productData, timeAgo);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ProductDetail(
                mainProvider: mainProvider,
              )
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, style: BorderStyle.solid),
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5)
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width*0.4,

                child: Image.network(
                  productData['url'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),


            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: [
                  Text(
                      productData['userName'].length > 15 ?
                      '${productData['userName'].substring(0,15)}...' :
                      productData['userName'],
                    style: GoogleFonts.mPlusRounded1c(
                      textStyle: TextStyle(
                          color: Colors.green[900],
                          fontWeight: FontWeight.w600,
                          fontSize: 12
                      ),
                    )
                  ),
                  const SizedBox(width: 10,),
                  Text(timeAgo,
                  style: GoogleFonts.mPlusRounded1c(
                    textStyle: const TextStyle(
                        color: Colors.black54,
                        fontSize: 10
                    ),
                  )
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10,),
              child: Text(
                  productData['title'].length > 36
                      ? '${productData['title'].substring(0, 36)}...'
                      : productData['title'],
                style: GoogleFonts.mPlusRounded1c(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                softWrap: true,
              ),
            ),

          ],
        ),
      ),
    );
  }



}