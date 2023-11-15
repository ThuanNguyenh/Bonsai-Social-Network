import 'package:bonsai_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../buttons/auth_button.dart';

// ignore: camel_case_types
class changePassword extends StatefulWidget {
  const changePassword({Key? key}) : super(key: key);

  @override
  State<changePassword> createState() => _changePasswordState();
}

// ignore: camel_case_types
class _changePasswordState extends State<changePassword> {
  late bool loading = false;

  final _formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  bool isCurrentPasswordObscured = true;

  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Hàm kiểm tra yêu cầu về mật khẩu mới
      bool isValidPassword(String password) {
        return password.length >= 6
        // && password.contains(RegExp(r'[A-Za-z]'))
        // && password.contains(RegExp(r'[0-9]'))
            ;
      }

      if (user != null) {
        // Xác thực người dùng
        AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: currentPassword);
        try {
          await user.reauthenticateWithCredential(credential);
          // Kiểm tra xem mật khẩu mới có giống với mật khẩu cũ không
          if (currentPassword != newPassword) {
            // Kiểm tra yêu cầu mật khẩu mới
            if (isValidPassword(newPassword)) {
              await user.updatePassword(newPassword);
              Utils().toastMessage('Cập nhật thành công!');
              // Cập nhật mật khẩu trong Firebase Realtime Database
              // await FirebaseDatabase.instance
              //     .reference()
              //     .child('User/${user.uid}/password')
              //     .set(newPassword);
            } else {
              Utils().toastMessage('Mật khẩu ít nhất 6 ký tự');
            }

          } else {
            Utils().toastMessage('Mật khẩu mới phải khác mật khẩu cũ!');
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            Utils().toastMessage('Mật khẩu không đúng.');
          } else {
            Utils().toastMessage(e as String);
          }
        } catch (error) {
          Utils().toastMessage(error.toString());
        }

        setState(() {
          loading = false;
        });
      } else {
        Utils().toastMessage('Cập nhật thất bại!');
        setState(() {
          loading = false;
        });
      }
    } on FirebaseAuthException catch (error) {
      Utils().toastMessage(error as String);
      setState(() {
        loading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text(
          "Đổi mật khẩu",
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

      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [

                // form đoỏi password
                Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      // mật khẩu cũ
                      TextFormField(
                        obscureText: isCurrentPasswordObscured,
                        controller: currentPasswordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nhập mật khẩu cũ';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'Mật khẩu cũ',
                            hintStyle: GoogleFonts.mPlusRounded1c(
                                textStyle: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,

                                )
                            )
                        ),
                      ),


                      // New Password
                      TextFormField(
                        obscureText: isCurrentPasswordObscured,
                        controller: newPasswordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nhập mật khẩu mới';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Mật khẩu mới',
                          hintStyle: GoogleFonts.mPlusRounded1c(
                            textStyle: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,

                            )
                          )
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          setState(() {
                            isCurrentPasswordObscured = !isCurrentPasswordObscured;
                          });
                        },
                        child: Text(
                          isCurrentPasswordObscured ? 'Hiện' : 'Ẩn',
                          style: GoogleFonts.mPlusRounded1c(
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500
                            )
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // Button to change password
                      AuthButton(
                        title: 'Lưu thay đổi',
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });

                            // gọi hàm changePassword
                            await changePassword(
                              currentPasswordController.text,
                              newPasswordController.text,
                            );

                            setState(() {
                              loading = false;
                            });



                          }
                        },
                        loading: loading,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }
}
