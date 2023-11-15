import 'package:bonsai_shop/network/data.dart';
import 'package:bonsai_shop/screens/products/my_products.dart';
import 'package:flutter/material.dart';
import 'package:bonsai_shop/screens/home/home.dart';
import 'package:bonsai_shop/screens/accounts/profile.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: non_constant_identifier_names
  List Screens = [
    Home(data: data.last),
    const Blogs(),
    const Profile(),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black38,
        selectedLabelStyle: GoogleFonts.mPlusRounded1c(
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500
          )
        ),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            label: 'Tin tức',

          ),


          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Bài viết',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Tài Khoản',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightGreen[900],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: Screens[_selectedIndex],
    );
  }
}
