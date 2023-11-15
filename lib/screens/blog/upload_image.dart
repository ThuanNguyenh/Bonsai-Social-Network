 import 'dart:async';
import 'dart:io';

import 'package:bonsai_shop/buttons/auth_button.dart';
import 'package:bonsai_shop/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImages extends StatefulWidget {
  const UploadImages({Key? key}) : super(key: key);

  @override
  State<UploadImages> createState() => _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {

  late bool loading = false;

  File? _image ;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Image');

  Future getImageGallery()async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if(pickedFile != null){
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Upload image'),
        backgroundColor: Colors.lightGreen,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
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
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    )
                  ),
                  child: _image != null ? Image.file(_image!.absolute) :const Icon(Icons.image),
                ),
              ),
            ),
            const SizedBox(height: 40,),

            AuthButton(
                title: 'Upload',
                onTap: ()async{

                  setState(() {
                    loading = true;
                  });

                  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(
                      '/foldername/${DateTime.now().millisecondsSinceEpoch}');
                  firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);

                  await Future.value(uploadTask);
                  var newUrl = await ref.getDownloadURL();

                  String id = DateTime.now().millisecondsSinceEpoch.toString() ;


                  databaseRef.child(id).set({
                    'id': id,
                    'image' : newUrl.toString()
                  }).then((value) {
                    Utils().toastMessage('Uploaded!');
                    setState(() {
                      loading = false;
                    });
                  }).onError((error, stackTrace) {
                    Utils().toastMessage('Lỗi');
                    setState(() {
                      loading = false;
                    });
                  });



                },
                loading: loading
            )
          ],
        ),
      ),
    );
  }
}
