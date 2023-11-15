import 'package:bonsai_shop/main.dart';
import 'package:bonsai_shop/screens/products/product_detail.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:core';

import 'package:provider/provider.dart';

class Product {
  final String name;
  final String imagePath;

  Product({required this.name, required this.imagePath});
}

class TypeProducts extends StatefulWidget {
  const TypeProducts({Key? key}) : super(key: key);

  @override
  State<TypeProducts> createState() => _TypeProductsState();
}

class _TypeProductsState extends State<TypeProducts> {

  final ref = FirebaseDatabase.instance.ref('Post');
  bool loading = false;

  late MainProvider mainProvider;



  @override
  Widget build(BuildContext context) {
    mainProvider = Provider.of<MainProvider>(context);
    return
        StreamBuilder(
          stream: ref.onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
              Map<dynamic, dynamic> map =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
              List<dynamic> list = [];
              list.clear();
              list = map.values.toList();

              // Sắp xếp theo thời gian mới nhất
              list.sort((a, b) => (b['createdAt'] ?? 0).compareTo(a['createdAt'] ?? 0));

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: List.generate(list.length, (index) {
                    return Column(
                      children: [
                        buildProductContainer(list[index], mainProvider),
                        const SizedBox(height: 10),
                      ],
                    );
                  }),
                ),
              );
            } else {
              // Loading indicator or placeholder for when data is still loading
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
  }

  Widget buildProductContainer(Map<dynamic, dynamic> productData, mainProvider) {
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
              builder: (_) => ProductDetail(mainProvider: mainProvider,)
          ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          // color: Colors.greenAccent[100],
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            Row (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox.fromSize(
                    size: Size(MediaQuery.of(context).size.width * 0.35, MediaQuery.of(context).size.width * 0.25),
                    child: Image.network(
                      productData['url'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      productData['title'].length > 60
                          ? '${productData['title'].substring(0, 60)}...'
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

                    const SizedBox(height: 10,),
                    Row (
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                productData['userName'].length > 10 ?
                                '${productData['userName'].substring(0,10)}...' :
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

                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              child: Text(timeAgo,
                                  style: GoogleFonts.mPlusRounded1c(
                                    textStyle: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 10
                                    ),
                                  )
                              ),
                            )
                          ],
                        )


                  ],
                ))

              ],
            ),

            //  line
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: Colors.black12,
            )


          ],
        ),
      ),
    );
  }

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


}
