import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';

class ProductDetail extends StatefulWidget {
  final MainProvider mainProvider;

  const ProductDetail(
      {Key? key,
      required this.mainProvider})
      : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late bool loading;



  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? selectedProduct =
        widget.mainProvider.selectedProduct;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text(
          selectedProduct?['userName'] ?? 'No Data',
          style: GoogleFonts.mPlusRounded1c(
              textStyle:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54,
          size: 18,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        toolbarHeight: 50,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black12, // Border color
            height: 1.0, // Border height
          ),
        ),
      ),
      body: buildBody(selectedProduct),
    );
  }

  Widget buildBody(Map<dynamic, dynamic>? selectedProduct) {
    if (selectedProduct == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return buildContent();
    }
  }

  Widget buildContent() {
    Map<dynamic, dynamic>? selectedProduct =
        widget.mainProvider.selectedProduct;
    String? timeAgo1 = widget.mainProvider.selectedTimeAgo;
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
              child: Text(
                selectedProduct != null
                    ? selectedProduct['title']
                    : 'Loading...',
                style: GoogleFonts.mPlusRounded1c(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 18)),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 20, bottom: 10),
                  child: Text(
                    timeAgo1!,
                    style: GoogleFonts.mPlusRounded1c(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                            fontSize: 12)),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 5, bottom: 10),
                      child: const Icon(
                        Icons.remove_red_eye_sharp,
                        color: Colors.black38,
                        size: 15,
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        '${selectedProduct?['views'] ?? 0}',
                        style: GoogleFonts.mPlusRounded1c(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                                fontSize: 12)),
                      ),
                    )
                  ],
                ),
              ],
            ),

            // hình ảnh
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                    selectedProduct?['url'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * 0.6,
                  )
              ),
            ),

            // nội dung
            Container(
              margin: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
              child: Text(
                selectedProduct?['context'],
                style: GoogleFonts.mPlusRounded1c(
                    fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        )
      ],
    );
  }
}
