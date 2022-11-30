import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddScreen extends StatefulWidget{
  const AddScreen({Key? key}) : super(key:key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen>{

  Product product = Product("", "",  "", 0, "");
  String? _image;


  Future<void> createProduct (Product product, String? _image)async{
    CollectionReference newDoc = FirebaseFirestore.instance
        .collection('products');
    final currentUser = FirebaseAuth.instance;
    final json = {
      'uid' : currentUser.currentUser!.uid,
      'img' : _image!,
      'price' : product.price,
      'name' : product.name,
      'description' : product.desc,
      'CreatedTime' : Timestamp.now()
    };
    await newDoc.doc().set(json);
  }

  Future<void> createDefaultProduct (Product product)async{
    CollectionReference newDoc = FirebaseFirestore.instance
        .collection('products');
    final currentUser = FirebaseAuth.instance;
    final json = {
      'uid' : currentUser.currentUser!.uid,
      'img' : '/data/user/0/com.example.finalterm/cache/image_picker2313401157609972380.png',
      'price' : product.price,
      'name' : product.name,
      'description' : product.desc,
      'CreatedTime' : FieldValue.serverTimestamp()
    };
    await newDoc.doc().set(json);
  }

  Future getImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = image.path;
      setState(() => _image = imageTemporary);
    }on PlatformException catch(e){
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 60,
          centerTitle: true,
          leading: TextButton(
            child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white)),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: const Text(
              "Add",
              style: TextStyle(color: Colors.white)
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white)
              ),
              onPressed: () {
                _image==null
                    ? createDefaultProduct(product)
                    : createProduct(product, _image!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child:
                  _image == null
                      ? Image.network('http://handong.edu/site/handong/res/img/logo.png')
                      : Image.file(File(_image!)),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () => getImage(),
                        icon: const Icon(Icons.camera_alt_outlined))
                  ],
                ),

                TextField(decoration: const InputDecoration(labelText: 'Product Name'),
                    onChanged: (val){product.setProductName(val);}),

                TextField(decoration: const InputDecoration(labelText: 'Price'),
                    onChanged: (val){product.setPrice(int.parse(val));}),

                TextField(decoration: const InputDecoration(labelText: 'Description'),
                    onChanged: (val){product.setDesc(val);}),
              ]
          ),)
    );
  }
}

class Product {
  Product(this.userId,  this.img, this.name, this.price, this.desc);
  String userId;
  String img;
  String name;
  int price;
  String desc;

  String getUserId(){return userId;}
  String getImg(){return img;}
  String getProductName() {return name;}
  int getPrice(){return price;}
  String getDesc(){return desc;}

  void setUserId(String val){userId=val;}
  void setImg(String val){img=val;}
  void setProductName(String val) {name=val;}
  void setPrice(int val){price=val;}
  void setDesc(String val){desc=val;}
}