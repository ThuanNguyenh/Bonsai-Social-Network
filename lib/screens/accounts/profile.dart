import 'dart:async';

import 'package:bonsai_shop/screens/auth/login.dart';
import 'package:bonsai_shop/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bonsai_shop/screens/auth/change_password.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final auth = FirebaseAuth.instance;

  // Giới hạn ký tự của username
  final maxLength = 20;
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
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Cá nhân",
        style: GoogleFonts.mPlusRounded1c(
          textStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 15
          )
        ),),
        centerTitle: true,
        toolbarHeight: 40,
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Image.asset(
                'lib/images/start1.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),

              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 170),
                padding: const EdgeInsets.only(left: 15),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      backgroundColor: CupertinoColors.opaqueSeparator,
                      radius: 22,
                      child: ClipOval(
                        child: Icon(
                          Icons.person_sharp,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                 _truncateUsername(username, maxLength),
                                style: GoogleFonts.mPlusRounded1c(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600
                                  )
                                )
                              ),


                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Column(
              children: [
                InkWell(
                  onTap: (){
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: (
                                  const Icon(Icons.remove_red_eye_outlined,
                                    color: Colors.black54,
                                    size: 25,
                                  ))),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                            child: Text(
                              'Bảo vệ mắt',
                              style: GoogleFonts.mPlusRounded1c(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          )
                        ],
                      ),

                    ],
                  ),
                ),
                //
                InkWell(
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const changePassword()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: (
                                  const Icon(Icons.password,
                                    color: Colors.black54,
                                    size: 25,
                                  ))),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                            child: Text(
                              'Đổi mật khẩu',
                              style: GoogleFonts.mPlusRounded1c(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          )
                        ],
                      ),

                    ],
                  ),
                ),
                // đăng xuất

                InkWell(
                  onTap: () {
                    auth.signOut().then((value) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const Login()));
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: (
                                  const Icon(Icons.exit_to_app,
                                    color: Colors.black54,
                                    size: 25,
                                  ))),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                            child: Text(
                              'Đăng xuất',
                              style: GoogleFonts.mPlusRounded1c(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          )
                        ],
                      ),

                    ],
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}
