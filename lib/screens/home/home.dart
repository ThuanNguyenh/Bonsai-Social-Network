import 'package:bonsai_shop/main.dart';
import 'package:bonsai_shop/model/post.dart';
import 'package:bonsai_shop/screens/products/type_product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'slider_home.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  final Post data;
  const Home({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final auth = FirebaseAuth.instance;

  final ref = FirebaseDatabase.instance.ref('Post');

  bool loading = false;

  Future<void> _refreshData() async {
    // Add logic to refresh your data here
    // For example, you can re-fetch data from Firebase
    setState(() {
      loading = true;
    });
    await Future.delayed(const Duration(seconds: 2)); // Simulating a network request delay

    setState(() {
      loading = false;
    });
  }

  // Giới hạn ký tự của username
  final maxLength = 7;
  String _truncateUsername(String? username, int maxLength) {
    if (username == null || username.length <= maxLength) {
      return username ?? '';
    } else {
      return '${username.substring(0, maxLength)}...';
    }
  }


  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);
    String? username = mainProvider.userName;
    return RefreshIndicator(
        onRefresh: _refreshData,
        child: Scaffold(
          // backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.lightGreen[900],
            automaticallyImplyLeading: false,
            title: Container(
              height: 52,
              width: 150,
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('lib/images/bonsai_logo.png'),
                ],
              ),
            ),
            actions: [
              Center(
                child: Text('Xin chào, ${_truncateUsername(username, maxLength)}!',
                style: GoogleFonts.mPlusRounded1c(
                  textStyle: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: 13
                  )
                ),),
              ),

              const SizedBox(width: 10,)

            ],
          ),
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [];
            },
            body: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 0, bottom: 70),
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
                          child: Text('ĐỌC NHIỀU', style: GoogleFonts.mPlusRounded1c(
                            textStyle: TextStyle(
                                color: Colors.green[900],
                                fontWeight: FontWeight.w500,
                                fontSize: 12
                            ),
                          )),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          margin: const EdgeInsets.only(top: 10),
                          child: const SliderHome(),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    // Tin mới nhất
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      // padding: EdgeInsets.only(left: 10, right: 10),
                      margin: const EdgeInsets.only(
                        top: 10,
                        bottom: 25,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 10, bottom: 10),
                                child: Text(
                                    'MỚI NHẤT',
                                    style: GoogleFonts.mPlusRounded1c(
                                      textStyle: TextStyle(
                                        color: Colors.green[900],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                ),
                              ),
                            ],
                          ),
                          const TypeProducts(),

                        ],
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
    );
  }
}
