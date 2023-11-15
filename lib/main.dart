import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:bonsai_shop/screens/auth/login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
      create: (_) => MainProvider(),
      child: const MaterialApp(debugShowCheckedModeBanner: false, home: MainHome())));
}

class MainProvider extends ChangeNotifier {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  late String _userName;
  final List<Map<dynamic, dynamic>> _savedProducts = [];
  Map<dynamic, dynamic>? _selectedProduct;
  String? _selectedTimeAgo;

  String get userName => _userName;
  List<Map<dynamic, dynamic>> get savedProducts => _savedProducts;
  Map<dynamic, dynamic>? get selectedProduct => _selectedProduct;
  String? get selectedTimeAgo => _selectedTimeAgo;

  void saveProduct(Map<dynamic, dynamic> productData, String timeAgo) {
    _savedProducts.add(productData);
    notifyListeners(); // Notify listeners to rebuild widgets that depend on this data
  }

  set username(String? value) {
    _userName = value!;
    notifyListeners();
  }

  void setSelectedProduct(Map<dynamic, dynamic> product, String timeAgo) {
    _selectedProduct = product;
    _selectedTimeAgo = timeAgo;
    incrementViewCount();
    notifyListeners();
  }

  void incrementViewCount() {
    if (_selectedProduct != null) {
      // Giả sử cấu trúc dữ liệu sản phẩm của bạn có trường 'viewCount'
      _selectedProduct!['views'] = (_selectedProduct!['views'] ?? 0) + 1;

      // Tăng số lần xem trên Firebase Realtime Database
      _databaseReference.child('Post/${_selectedProduct!['id']}').update({
        'views': _selectedProduct!['views'],
      });

      notifyListeners();
    }
  }

}

class MainHome extends StatelessWidget {
  const MainHome({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // banner
          Image.asset(
            'lib/images/start1.jpg',
            fit: BoxFit.fill,
            color: const Color.fromRGBO(156, 156, 156, 1),
            colorBlendMode: BlendMode.modulate,
            width: double.infinity,
            height: double.infinity,
          ),

          Column(
            children: [
              // Text('Data from Firebase: ${mainProvider.data ?? 'Loading...'}'),
              Container(
                margin: const EdgeInsets.only(top: 200, left: 30, right: 100),
                child: Text(
                  'Blog cây cảnh',
                  style: GoogleFonts.mPlusRounded1c(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 30
                    )
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, left: 30, right: 90),
                child: Text(
                  'Không chỉ là màu xanh của chiếc lá, Anh còn là cả bầu trời thanh xuân!',
                  style: GoogleFonts.mPlusRounded1c(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500
                    )
                    )
                  ),
              )
            ],
          ),

          // content
          Container(
            margin: const EdgeInsets.only(top: 600, left: 100, right: 100),
            child: Column(
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.white,
                    minimumSize: const Size(200, 45),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const Login()));
                  },
                  child: Text(
                    'Đăng nhập',
                    style: GoogleFonts.mPlusRounded1c(
                      textStyle: const TextStyle(
                        color: Colors.lightGreen,
                        fontSize: 15,
                        fontWeight: FontWeight.w600
                      )
                    ),
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
