
import 'dart:io';

import 'package:bonsai_shop/buttons/auth_button.dart';
import 'package:bonsai_shop/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';


class AddBlogs extends StatefulWidget {
  const AddBlogs({Key? key}) : super(key: key);


  @override
  State<AddBlogs> createState() => _AddBlogsState();
}

class _AddBlogsState extends State<AddBlogs> {

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final titleController = TextEditingController();

  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Post');

  // upload image
  File? _image ;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  // DatabaseReference databaseImageRef = FirebaseDatabase.instance.ref('Post');

  Future getImageGallery()async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if(pickedFile != null){
        _image = File(pickedFile.path);
      }
    });
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


  Future<void> savePostToDatabase() async {

    // lấy thông tin từ người dùng hiện tại từ FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // lấy uid ngươif dùng tù FirebaseAuth
      String userUid = user.uid;

      // Lấy UID và username từ Realtime Database
      Map<String, dynamic>? userData = await getUsernameFromDatabase(userUid);


      if (userData != null) {
        String usernameFromDatabase = userData['username'] ?? '';
        String id = userData['id'];

        // So sánh UID từ FirebaseAuth với UID từ Realtime Database
        if (id.isNotEmpty && id == userUid) {
          // upload image
          firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
              .ref('/foldername/${DateTime.now().millisecondsSinceEpoch}');
          firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);

          await Future.value(uploadTask);
          var newUrl = await ref.getDownloadURL();

          String id = DateTime.now().millisecondsSinceEpoch.toString();

          // Lưu thông tin bài viết vào Realtime Database
          databaseRef.child(id).set({
            'id': id,
            'title': titleController.text.toString(),
            'url': newUrl.toString(),
            'context': nameController.text.toString(),
            'userId': user.uid,
            'userName': usernameFromDatabase,
            'createdAt': ServerValue.timestamp,
          }).then((value) {
            Utils().toastMessage('Thành công!');
            setState(() {
              loading = false;
            });
          }).onError((error, stackTrace) {
            Utils().toastMessage('Lỗi!');
            setState(() {
              loading = false;
            });
          });

        } else {
          Utils().toastMessage("UID không khớp hoặc không tìm thấy thông tin người dùng.");
          setState(() {
            loading = false;
          });
        }


      }


    } else {
      Utils().toastMessage("Không thể tìm thấy thông tin người dùng.");
      setState(() {
        loading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tạo bài viết',
        style: GoogleFonts.mPlusRounded1c(
          textStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 15
          )
        ),
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
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 25,),

                // upload image
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: InkWell(
                        onTap: (){
                          getImageGallery();
                        },
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(5))
                          ),
                          child: _image != null ? Image.file(_image!.absolute) : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.image, color: Colors.lightGreen,),
                              Text('Thêm hình ảnh', style: GoogleFonts.mPlusRounded1c(
                                textStyle: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400
                                )
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 15,),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [

                        TextFormField(
                          maxLines: 1,
                          controller: titleController,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Hãy nhập nội dung !';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Tiêu đề',
                            hintStyle: GoogleFonts.mPlusRounded1c(
                              textStyle: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w400,
                                fontSize: 13
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 1
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15,),

                        TextFormField(
                          maxLines: null,
                          controller: nameController,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Hãy nhập nội dung !';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Nội dung',
                            hintStyle: GoogleFonts.mPlusRounded1c(
                                textStyle: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13
                                )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),

                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1
                              ),
                            ),
                          ),
                        ),




                      ],
                    )),

                const SizedBox(height: 60,),

                AuthButton(
                    title: 'Đăng bài',
                    onTap: ()async{
                      if(_formKey.currentState!.validate()){
                        setState(() {
                          loading = true;
                        });
                        await savePostToDatabase();
                      }
                    },
                    loading: loading),
              ],
            ),
          )
        ],
      ),
    );
  }


}
