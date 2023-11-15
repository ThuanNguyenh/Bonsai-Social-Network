import 'package:bonsai_shop/main.dart';
import 'package:bonsai_shop/screens/products/add_products.dart';
import 'package:bonsai_shop/screens/products/product_detail.dart';
import 'package:bonsai_shop/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Blogs extends StatefulWidget {
  const Blogs({Key? key}) : super(key: key);

  @override
  State<Blogs> createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  final bool loading = false;

  final auth = FirebaseAuth.instance;
  late User? currentUser; // Để lưu trữ người dùng đang được xác thực hiện tại

  final ref = FirebaseDatabase.instance.ref('Post');

  //search
  final searchFilter = TextEditingController();

  // edit
  final _formKey = GlobalKey<FormState>();
  final editController = TextEditingController();
  final ePriceController = TextEditingController();
  final eAddressController = TextEditingController();
  final eImageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser = auth.currentUser;
  }

  late MainProvider mainProvider;

  @override
  Widget build(BuildContext context) {
    mainProvider = Provider.of<MainProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Bài viết của tôi',
        style: GoogleFonts.mPlusRounded1c(
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500
          )
        ),),
        centerTitle: true,
        toolbarHeight: 50,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10,),

          // search
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 0
            ),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius:const BorderRadius.all(Radius.circular(10)),
                  boxShadow:[
                    BoxShadow(
                      color: Colors.grey.shade300,
                      offset: const Offset(3.0, 3.0),
                      blurRadius: 10.0,
                      spreadRadius: 5.0,

                    )
                  ]
              ),
              child: TextFormField(
                controller: searchFilter,
                decoration: const InputDecoration(
                    hintText: 'Tìm kiếm',
                    hintStyle: TextStyle(fontSize: 13, color: Colors.black54),
                    prefixIcon: Icon(Icons.search, color: Colors.black54,),
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true
                ),
                onChanged: (String value) {
                  setState(() {});
                },
              ),
            ),
          ),
          Expanded(
              child: StreamBuilder(
                stream: ref.orderByChild('userId').equalTo(currentUser?.uid).onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                    Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                    List<dynamic> list = map.values.toList();

                  //  Sắp xếp thời gian gần nhất
                    list.sort((a, b) => (b['createdAt'] ?? 0).compareTo(a['createdAt'] ?? 0));
                    return FirebaseAnimatedList(
                        query: ref.orderByChild('userId').equalTo(currentUser?.uid),
                        padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                        itemBuilder: (context, snapshot, animation, index) {
                          final name = snapshot.child('title').value.toString();
                          final address = snapshot.child('context').value.toString();

                          if (searchFilter.text.isEmpty) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 105,
                                  child: ListTile(
                                    contentPadding:
                                    const EdgeInsets.only(left: 10),
                                    visualDensity: const VisualDensity(
                                        vertical: 4, horizontal: 0),
                                    leading: InkWell(
                                      onTap: (){
                                        mainProvider.setSelectedProduct(snapshot.value as Map, snapshot.child('createdAt').value!.toString());
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetail( mainProvider: mainProvider,)));
                                      },
                                      child: SizedBox(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          child: SizedBox.fromSize(
                                              size: const Size.square(110),
                                              child: Image.network(
                                                snapshot.child('url').value.toString(),
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                              )),
                                        ),
                                      ),
                                    ),
                                    title: InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetail(
                                          mainProvider: mainProvider,
                                        )));
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 10, bottom: 5),
                                        child: Text(
                                          snapshot.child('title').value.toString().length > 35
                                              ? '${snapshot.child('title').value.toString().substring(0,47)}...'
                                              : snapshot.child('title').value.toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    subtitle: InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetail(mainProvider: mainProvider,)));
                                      },
                                      child: Column(
                                        // margin: const EdgeInsets.only(top: 5),
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${snapshot.child('userName').value.toString().length > 14 ?
                                            '${snapshot.child('userName').value.toString().substring(0,14)}...':
                                            snapshot.child('userName').value.toString()
                                            } ',
                                            style: GoogleFonts.mPlusRounded1c(
                                                textStyle: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400)
                                            ),
                                          ),
                                          // Text(
                                          //   snapshot.child('createdAt').value.toString(),
                                          //   style: GoogleFonts.mPlusRounded1c(
                                          //       textStyle: const TextStyle(
                                          //           color: Colors.grey,
                                          //           fontSize: 12,
                                          //           fontWeight: FontWeight.w400)
                                          //   ),
                                          // )
                                        ],
                                      ),

                                    ),
                                    isThreeLine: true,
                                    trailing: PopupMenuButton(
                                      icon: const Icon(Icons.more_vert),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                            value: 3,
                                            child: ListTile(
                                              onTap: () async{
                                                Navigator.pop(context);


                                                showMyDialog(name, address, snapshot.child('id').value.toString());



                                              },
                                              leading: const Icon(Icons.edit),
                                              title: const Text('Sửa'),
                                            )),
                                        PopupMenuItem(
                                            value: 1,
                                            child: ListTile(
                                              onTap: () {
                                                Navigator.pop(context);
                                                ref
                                                    .child(snapshot
                                                    .child('id')
                                                    .value
                                                    .toString())
                                                    .remove();
                                              },
                                              leading:
                                              const Icon(Icons.delete_outline),
                                              title: const Text('Xóa'),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.black12,
                                  height: 1,
                                )
                              ],
                            );
                          } else if (name.toLowerCase().contains(
                              searchFilter.text.toLowerCase().toLowerCase())) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 105,
                                  child: ListTile(
                                    contentPadding:
                                    const EdgeInsets.only(left: 10),
                                    visualDensity: const VisualDensity(
                                        vertical: 4, horizontal: 0),
                                    leading: InkWell(
                                      onTap: (){
                                        mainProvider.setSelectedProduct(snapshot.value as Map, snapshot.child('createdAt').value!.toString());
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetail( mainProvider: mainProvider,)));
                                      },
                                      child: SizedBox(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          child: SizedBox.fromSize(
                                              size: const Size.square(110),
                                              child: Image.network(
                                                snapshot.child('url').value.toString(),
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                              )),
                                        ),
                                      ),
                                    ),
                                    title: InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetail(
                                          mainProvider: mainProvider,
                                        )));
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 10, bottom: 5),
                                        child: Text(
                                          snapshot.child('title').value.toString().length > 35
                                              ? '${snapshot.child('title').value.toString().substring(0,47)}...'
                                              : snapshot.child('title').value.toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    subtitle: InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetail(mainProvider: mainProvider,)));
                                      },
                                      child: Column(
                                        // margin: const EdgeInsets.only(top: 5),
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${snapshot.child('userName').value.toString().length > 14 ?
                                            '${snapshot.child('userName').value.toString().substring(0,14)}...':
                                            snapshot.child('userName').value.toString()
                                            } ',
                                            style: GoogleFonts.mPlusRounded1c(
                                                textStyle: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400)
                                            ),
                                          ),
                                          // Text(
                                          //   snapshot.child('createdAt').value.toString(),
                                          //   style: GoogleFonts.mPlusRounded1c(
                                          //       textStyle: const TextStyle(
                                          //           color: Colors.grey,
                                          //           fontSize: 12,
                                          //           fontWeight: FontWeight.w400)
                                          //   ),
                                          // )
                                        ],
                                      ),

                                    ),
                                    isThreeLine: true,
                                    trailing: PopupMenuButton(
                                      icon: const Icon(Icons.more_vert),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                            value: 3,
                                            child: ListTile(
                                              onTap: () async{
                                                Navigator.pop(context);


                                                showMyDialog(name, address, snapshot.child('id').value.toString());



                                              },
                                              leading: const Icon(Icons.edit),
                                              title: const Text('Sửa'),
                                            )),
                                        PopupMenuItem(
                                            value: 1,
                                            child: ListTile(
                                              onTap: () {
                                                Navigator.pop(context);
                                                ref
                                                    .child(snapshot
                                                    .child('id')
                                                    .value
                                                    .toString())
                                                    .remove();
                                              },
                                              leading:
                                              const Icon(Icons.delete_outline),
                                              title: const Text('Xóa'),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.black12,
                                  height: 1,
                                )
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                        defaultChild: const Center(
                          child: CircularProgressIndicator(),
                        ));
                  } else {
                    return Center(
                        child: Text("Chưa có bài viết",
                        style: GoogleFonts.mPlusRounded1c(
                          textStyle: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500
                          )
                        ),
                      ),
                    );
                  }
                },
              )
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),

      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          backgroundColor: Colors.lightGreen,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AddBlogs()));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> showMyDialog(
      String name,
      String address,
      String id,
      ) async {
    editController.text = name;
    eAddressController.text = address;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Chỉnh sửa',
            style: GoogleFonts.mPlusRounded1c(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15
              )
            ),
            ),
            content: SizedBox(
                height: MediaQuery.of(context).size.width,
                child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        TextFormField(
                          style: GoogleFonts.mPlusRounded1c(
                            textStyle: const TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontWeight: FontWeight.w400
                            )
                          ),
                          maxLines: null,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Hãy nhập nội dung !';
                            }
                            return null;
                          },
                          controller: editController,
                          decoration: const InputDecoration(
                            hintText: 'Tiêu đề',
                            labelText: "Tiêu đề",
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                            )
                          ),
                        ),
                        TextFormField(
                          maxLines: null,
                          style: GoogleFonts.mPlusRounded1c(
                              textStyle: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400
                              )
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Hãy nhập nội dung !';
                            }
                            return null;
                          },
                          controller: eAddressController,
                          decoration: const InputDecoration(
                            hintText: 'Nội dung',
                              labelText: "Nội dung",
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600
                              )
                          ),
                        ),
                      ],
                    ))
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Hủy')),
              TextButton(
                  onPressed: () {
                    if(_formKey.currentState!.validate()){
                      Navigator.pop(context);
                      ref.child(id).update({
                        'title': editController.text.toLowerCase(),
                        'context' : eAddressController.text.toLowerCase(),
                      }).then((value) {
                        Utils().toastMessage('Sửa thành công!');
                      }).onError((error, stackTrace) {
                        Utils().toastMessage(error.toString());
                      });
                    }

                  },
                  child: const Text('Cập nhật'))
            ],
          );
        });
  }
}
