import 'package:bonsai_shop/buttons/auth_button.dart';
import 'package:bonsai_shop/homepage.dart';
import 'package:bonsai_shop/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:bonsai_shop/screens/auth/signup.dart';
import 'package:bonsai_shop/screens/auth/forgot_password.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bonsai_shop/main.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {

  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final _auth = FirebaseAuth.instance;

  // show the password or not
  final bool _isObscure = true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() async {
    setState(() {
      loading = true;
    });

    try {
      var value = await _auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text.toString());
      Utils().toastMessage(value.user!.email.toString());

      // Luu ten dang nhap
      User? user = FirebaseAuth.instance.currentUser;
      String userUid = user!.uid;

      Map<String, dynamic>? userData = await getUsernameFromDatabase(userUid);

      if (userData != null) {
        String username = userData['username'] ?? '';
        String id = userData['id'];

        if (id.isNotEmpty && id == userUid) {
          String name = username;

        //  cap nhat mainProvider
          // ignore: use_build_context_synchronously
          Provider.of<MainProvider>(context, listen: false).username = name;
        }
      }

      // ignore: use_build_context_synchronously
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const HomePage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        Utils().toastMessage("Mật khẩu không đúng!");
      } else if (e.code == 'user-not-found') {
        Utils().toastMessage('Tài khoản không tồn tại!');
      } else if(e.code == 'invalid-email'){
        Utils().toastMessage('Email không đúng!');
      } else {
        Utils().toastMessage('Lỗi đăng nhập!');
      }
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<Map<String, dynamic>?> getUsernameFromDatabase(String uid) async {
    try {
      DatabaseReference userRef = FirebaseDatabase.instance.ref().child('User/$uid');

      // Sử dụng callback để lấy ra dataSnapshot
      DataSnapshot dataSnapshot = await userRef.once().then((event) {
        final snapshot = event.snapshot;
        return snapshot;
      });

      // Kiểm tra xem dataSnapshot có phải là kiểu map không
      if (dataSnapshot.value is Map<dynamic, dynamic>) {
        Map<String, dynamic> userData = {};
        (dataSnapshot.value as Map<dynamic, dynamic>).forEach((key, value) {
          userData[key.toString()] = value;
        });
        return userData;
      } else {
        return null;
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      return null;
    }
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async{
          SystemNavigator.pop();
          return true;
        },
        child: Scaffold(
         body: ListView(
           children: [
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
               child: Center(
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: <Widget>[
                       SizedBox(
                         height: 150,
                         child: Image.asset('lib/images/logo.png'),
                       ),

                       const SizedBox(
                         height: 40,
                       ),

                       // text fiel
                       Form(
                           key: _formKey,
                           child: Column(
                             children: [
                               TextFormField(
                                 controller: emailController,
                                 keyboardType: TextInputType.emailAddress,

                                 validator: (value){
                                   if(value!.isEmpty){
                                     return 'Vui lòng nhập email';
                                   }
                                   return null;
                                 },
                                 decoration: InputDecoration(
                                   border: const OutlineInputBorder(
                                       borderRadius: BorderRadius.all(Radius.circular(5))
                                   ),
                                   labelText: 'Email',
                                     labelStyle: GoogleFonts.mPlusRounded1c(
                                         textStyle: const TextStyle(
                                             color: Colors.black54,
                                             fontSize: 13,
                                             fontWeight: FontWeight.w400
                                         )),
                                   prefixIcon: const Icon(Icons.email, color: Colors.black54,size: 20,
                                   ),
                                   focusedBorder: const OutlineInputBorder(
                                     borderRadius: BorderRadius.all(Radius.circular(5)),
                                     borderSide: BorderSide(color: Colors.lightGreen)
                                   )
                                 ),
                               ),
                               const SizedBox(
                                 height: 20,
                               ),
                               TextFormField(
                                 keyboardType: TextInputType.text,
                                 controller: passwordController,

                                 obscureText: _isObscure,
                                 validator: (value){
                                   if(value!.isEmpty){
                                     return 'Vui lòng nhập mật khẩu';
                                   }
                                   return null;
                                 },
                                 decoration:  InputDecoration(
                                     border: const OutlineInputBorder(
                                         borderRadius: BorderRadius.all(Radius.circular(5))
                                     ),
                                     labelText: 'Mật khẩu',
                                     labelStyle: GoogleFonts.mPlusRounded1c(
                                       textStyle: const TextStyle(
                                         color: Colors.black54,
                                         fontSize: 13,
                                         fontWeight: FontWeight.w400
                                       )
                                     ),
                                     prefixIcon: const Icon(Icons.key, color: Colors.black54,size: 20,),
                                     focusedBorder: const OutlineInputBorder(
                                         borderRadius: BorderRadius.all(Radius.circular(5)),
                                         borderSide: BorderSide(color: Colors.lightGreen)
                                     )
                                 ),
                               ),


                             ],
                           )),
                       const SizedBox(
                         height: 10,
                       ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.end,
                         children: [
                           TextButton(
                               onPressed: () {
                                 Navigator.push(context,
                                     MaterialPageRoute(builder: (_) => const ForgotPassword()));
                               },
                               child: Text(
                                 'Quên mật khẩu?',
                                 style: GoogleFonts.mPlusRounded1c(
                                   textStyle: const TextStyle(
                                     color: Colors.lightGreen,
                                     fontWeight: FontWeight.w500,
                                     fontSize: 15
                                   )
                                 ),
                               )),
                         ],
                       ),

                       const SizedBox(height: 20,),

                       AuthButton(
                           title: 'Đăng nhập',
                           onTap: () async{
                             if(_formKey.currentState!.validate()){
                               login();
                             }
                           },
                           loading: loading),

                       const SizedBox(
                         height: 30,
                       ),


                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Text(
                             'Bạn chưa có tài khoản? ',
                             style: GoogleFonts.mPlusRounded1c(
                               textStyle: const TextStyle(
                                 color: Colors.black54,
                                 fontSize: 15,
                                 fontWeight: FontWeight.w500
                               )
                             ),
                           ),
                           TextButton(
                               onPressed: () {

                                 Navigator.push(context,
                                     MaterialPageRoute(builder: (_) => const SignUp()));
                               },
                               child: Text(
                                 'Đăng ký',
                                 style: GoogleFonts.mPlusRounded1c(
                                   textStyle: const TextStyle(
                                     color: Colors.lightGreen,
                                     fontWeight: FontWeight.w500,
                                     fontSize: 15
                                   )
                                 )
                               )),
                         ],
                       ),

                     ],
                   )
               ),
             ),
           ],

         )

          // This trailing comma makes auto-formatting nicer for build methods.
        )
        );
  }
}
