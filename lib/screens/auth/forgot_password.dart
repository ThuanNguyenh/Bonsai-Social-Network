
import 'package:bonsai_shop/buttons/auth_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/utils.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  late bool loading = false;

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text(
          'Quên mật khẩu',
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
          Padding(padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            children: [
              Form(
                key: _formKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: GoogleFonts.mPlusRounded1c(
                        textStyle: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 13
                        )
                      ),
                      prefixIcon: const Icon(Icons.email,
                        size: 18,
                      )
                    ),
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,

                    validator: (value) {
                      if (value!.isEmpty){
                        return 'Vui lòng nhập email';
                      } else {
                        return null;
                      }
                    },
                  )),

              const SizedBox(height: 50,),

              AuthButton(
                  title: 'Lấy lại mật khẩu',
                  onTap: (){
                    if(_formKey.currentState!.validate()){
                      setState(() {
                        loading = true;
                      });
                      auth.sendPasswordResetEmail(
                          email: emailController.text.toString()
                      ).then((value) {
                        Utils().toastMessage('Vui lòng kiểm tra email để lấy lại mật khẩu');
                        setState(() {
                          loading = false;
                        });
                      }).onError((error, stackTrace) {
                        Utils().toastMessage(error.toString());
                        setState(() {
                          loading = false;
                        });
                      });
                    }
                  },
                  loading: loading)
            ],
          ),)
        ],
      ),
    );
  }
}
