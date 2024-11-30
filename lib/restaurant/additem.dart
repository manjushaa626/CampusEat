import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

var ItemName = '';

class additem extends StatefulWidget {
  const additem({Key? key}) : super(key: key);

  @override
  State<additem> createState() => _additemState();
}

class _additemState extends State<additem> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _ratingCountController = TextEditingController();
  final TextEditingController _averageRatingController = TextEditingController();
  final TextEditingController _restaurantNameController = TextEditingController();

  void _addItemToFirebase() async {
    ItemName = _itemNameController.text.trim();

    // Check if user is authenticated
    if (FirebaseAuth.instance.currentUser != null) {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Fetch user document from Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(uid)
          .get();

      // Check if user document exists and contains a 'name' field
      if (userSnapshot.exists && userSnapshot.data() != null) {
        String restaurantName = userSnapshot.get('name');

        // Add item to Firestore with fetched restaurant name
        FirebaseFirestore.instance
            .collection('items')
            .doc(_itemNameController.text)
            .set({
          'itemName': _itemNameController.text,
          'price': double.parse(_priceController.text),
          'category': _categoryController.text,
          'rating': _ratingController.text,
          'ratingCount': _ratingCountController.text,
          'image': imageUrl,
          'averageRating': _averageRatingController.text,
          'restaurantName': restaurantName,
        }).then((value) => Get.snackbar('$ItemName is ready!!',
            "Get ready to try the newly added $ItemName",
            colorText: Colors.white, backgroundColor: Colors.green));
        log(_itemNameController.text.trim());

        _itemNameController.clear();
        _priceController.clear();
        _categoryController.clear();
      } else {
        print('User document not found or does not contain a "name" field.');
      }
    } else {
      print('User is not authenticated.');
    }
  }

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Add Food Item'),),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(
                width: 200,
                child: TextField(
                  controller: _itemNameController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent)),
                    hintText: 'Item name',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent)),
                    hintText: 'Price',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent)),
                    hintText: 'category',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12)),
                  ),
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file = await imagePicker.pickImage(
                        source: ImageSource.gallery);
                    print('${file?.path}');

                    String uniqueFileName =
                    DateTime.now().millisecondsSinceEpoch.toString();

                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages =
                    referenceRoot.child('images');
                    Reference referenceImagetoUpload =
                    referenceDirImages.child(uniqueFileName);

                    try {
                      await referenceImagetoUpload.putFile(File(file!.path));
                      imageUrl =
                      await referenceImagetoUpload.getDownloadURL();
                    } catch (error) {}
                  },
                  child: Text('Upload Image')),SizedBox(height: 20,),
              ElevatedButton(
                onPressed: _addItemToFirebase,
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
