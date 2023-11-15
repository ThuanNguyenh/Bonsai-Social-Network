import 'package:bonsai_shop/buttons/auth_button.dart';
import 'package:bonsai_shop/screens/auth/login.dart';
import 'package:bonsai_shop/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  bool loading = false;

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseRef = FirebaseDatabase.instance.ref('User');

  // show the password or not
  final bool _isObscure = true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
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
                            controller: userNameController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Vui lòng nhập tên đăng nhập';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black54),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))
                                    ),
                                hintStyle: GoogleFonts.mPlusRounded1c(),
                                labelText: 'Tên đăng nhập',
                                labelStyle: GoogleFonts.mPlusRounded1c(
                                  textStyle: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400
                                  )
                                ),
                                prefixIcon: const Icon(Icons.person,
                                color: Colors.black54,
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Vui lòng nhập email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black54),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))
                                    ),
                                labelText: 'Email',
                                labelStyle: GoogleFonts.mPlusRounded1c(
                                    textStyle: const TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400
                                    )),
                                prefixIcon: const Icon(Icons.email, color: Colors.black54,)),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: passwordController,
                            obscureText: _isObscure,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Vui lòng nhập mật khẩu';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black54),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))
                                    ),
                                labelText: 'Mật khẩu',
                                labelStyle: GoogleFonts.mPlusRounded1c(
                                  textStyle: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w400
                                  )),
                                prefixIcon: const Icon(Icons.key, color: Colors.black54,)),
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 40,
                  ),

                  AuthButton(
                      title: 'Đăng ký',
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });

                          try {
                            // kiểm tra tônf tại tên người dùng
                            DataSnapshot snapshot = (await databaseRef
                                .orderByChild('username')
                                .equalTo(userNameController.text.toString())
                                .once()).snapshot;
                            if (snapshot.value != null) {
                              Utils().toastMessage('Tên người dùng đã tồn tại');
                            } else {
                              // Lấy thông tin người dùng từ FirebaseAuth
                              UserCredential authResult =
                                  await _auth.createUserWithEmailAndPassword(
                                email: emailController.text.toString(),
                                password: passwordController.text.toString(),
                              );

                              // Lấy UID từ FirebaseAuth
                              String uid = authResult.user!.uid;

                              // Lưu thông tin người dùng vào realtime database
                              databaseRef.child(uid).set({
                                'id': uid,
                                'username': userNameController.text.toString(),
                                'email': emailController.text.toString(),
                                'password': passwordController.text.toString(),
                              });

                              Utils().toastMessage('Đăng ký thành công!');
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              Utils().toastMessage(
                                  'Mật khẩu ít nhất phải chứa 6 ký tự');
                            } else if (e.code == 'invalid-email') {
                              Utils().toastMessage('Sai định dạng email');
                            } else if (e.code == 'email-already-in-use') {
                              Utils().toastMessage('Email đã tồn tại');
                            } else {
                              Utils().toastMessage('Lỗi đăng ký!');
                            }
                          } finally {
                            setState(() {
                              loading = false;
                            });
                          }
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
                        'Bạn đã có tài khoản? ',
                        style: GoogleFonts.mPlusRounded1c(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const Login()));
                          },
                          child: Text('Đăng nhập',
                              style: GoogleFonts.mPlusRounded1c(
                                  color: Colors.lightGreen,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14))),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
