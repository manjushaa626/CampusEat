import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CustProfile extends StatefulWidget {
  const CustProfile({Key? key}) : super(key: key);

  @override
  State<CustProfile> createState() => _CustProfileState();
}

class _CustProfileState extends State<CustProfile> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  File? _image;
  String? _photoUrl;

  Future<void> _updatePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _savePhoto() async {
    if (_image != null) {
      // Upload image to Firebase Storage
      String? uid = _auth.currentUser?.uid;
      Reference ref = _storage.ref().child('user_photos').child('$uid.jpg');
      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String photoUrl = await taskSnapshot.ref.getDownloadURL();

      // Update photo URL in Firestore
      await _firestore.collection('User').doc(uid).update({
        'photoUrl': photoUrl,
      });

      setState(() {
        _photoUrl = photoUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("User Profile"),
      ),
      body: Center(
        child: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('User').doc(_auth.currentUser?.uid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text('No Data found');
            }

            var userData = snapshot.data!.data();
            DocumentSnapshot docSnapshot = snapshot.data!;
            String fieldData1 = (docSnapshot.get('name') ?? '').toString();
            String fieldData2 = (docSnapshot.get('email') ?? '').toString();
            String fieldData3 = (docSnapshot.get('phoneno') ?? '').toString();
            _photoUrl = (docSnapshot.get('photoUrl') ?? '').toString();

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _updatePhoto,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _image != null
                        ? FileImage(_image!) as ImageProvider<Object>
                        : (_photoUrl!.isNotEmpty ? NetworkImage(_photoUrl!) as ImageProvider<Object> : null),
                    backgroundColor: Colors.white,
                    child: (_image == null && _photoUrl!.isEmpty)
                        ? Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.redAccent,
                    )
                        : null,
                  ),
                ),
                ElevatedButton(
                  onPressed: _savePhoto,
                  child: Text('Update Photo'),
                ),
                SizedBox(height: 20),
                // Display other user information...
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(9.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.redAccent, // Customize the box color as needed
                      ),
                      child: Icon(
                        Icons.person, // Replace with your desired icon
                        color: Colors.white70, // Customize the icon color as needed
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      fieldData1,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(9.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.redAccent, // Customize the box color as needed
                      ),
                      child: Icon(
                        Icons.mail, // Replace with your desired icon
                        color: Colors.white70, // Customize the icon color as needed
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      fieldData2,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(9.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.redAccent, // Customize the box color as needed
                      ),
                      child: Icon(
                        Icons.phone, // Replace with your desired icon
                        color: Colors.white70, // Customize the icon color as needed
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      fieldData3,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),


              ],
            );
          },
        ),
      ),
    );
  }
}




class restprofile extends StatefulWidget {
  const restprofile({Key? key}) : super(key: key);

  @override
  State<restprofile> createState() => _restprofileState();
}

class _restprofileState extends State<restprofile> {
  @override
  Widget build(BuildContext context) {


    final FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference user = FirebaseFirestore.instance.collection('User');
    DocumentReference docRef = user.doc(auth.currentUser?.uid);

    return Scaffold( appBar: AppBar(backgroundColor: Colors.green,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          // Handle back arrow press
          Navigator.pop(context);
        },
      ),
      title: Text("User Profile"),
    ),

      body: Center(child:
      StreamBuilder<DocumentSnapshot>(
        stream: docRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Error...');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }
          if (!snapshot.hasData) {
            return const Text('No Data found');
          }
          DocumentSnapshot docSnapshot = snapshot.data!;
          String fieldData1 = (docSnapshot.get('name')).toString();
          String fieldData2 = (docSnapshot.get('email')).toString();
          String fieldData3 = (docSnapshot.get('phoneno')).toString();
          // editData['name'] = fieldData;

          return Center(
            child: (Column(crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.green,
                        ),
                      ), Text(
                        fieldData1,
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Container(

                            padding: EdgeInsets.all(9.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.green, // Customize the box color as needed
                            ),
                            child: Icon(
                              Icons.person, // Replace with your desired icon
                              color: Colors.white70, // Customize the icon color as needed
                            ),

                          ),
                          SizedBox(width: 10,),
                          Text(
                            fieldData1,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Container(

                            padding: EdgeInsets.all(9.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.green, // Customize the box color as needed
                            ),
                            child: Icon(
                              Icons.mail, // Replace with your desired icon
                              color: Colors.white70, // Customize the icon color as needed
                            ),

                          ),
                          SizedBox(width: 10,),
                          Text(
                            fieldData2,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Container(

                            padding: EdgeInsets.all(9.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.green, // Customize the box color as needed
                            ),
                            child: Icon(
                              Icons.phone, // Replace with your desired icon
                              color: Colors.white70, // Customize the icon color as needed
                            ),

                          ),
                          SizedBox(width: 10,),
                          Text(
                            fieldData3,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                        ],
                      ),
                      SizedBox(width: 8.0), // Adjust the spacing between the icon and text

                      SizedBox(height: 20),
                    ],
                  ),


                  SizedBox(height: 16.0),

                  // Text('Name: $fieldData1',style: TextStyle(fontSize: 34.0,
                  //    fontWeight: FontWeight.bold,),),
                  // Text('Email id:$fieldData2',style: TextStyle(color: Colors.purple,fontSize: 30),),
                  //Text(fieldData3,style: TextStyle(color: Colors.purple,fontSize: 40),),




                ])),
          );
        },
      ),
      ),
    );
  }}




class dbprofile extends StatefulWidget {
  const dbprofile({Key? key}) : super(key: key);

  @override
  State<dbprofile> createState() => _dbprofileState();
}

class _dbprofileState extends State<dbprofile> {
  @override
  Widget build(BuildContext context) {


    final FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference user = FirebaseFirestore.instance.collection('User');
    DocumentReference docRef = user.doc(auth.currentUser?.uid);

    return Scaffold( appBar: AppBar(backgroundColor: Colors.green,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          // Handle back arrow press
          Navigator.pop(context);
        },
      ),
      title: Text("User Profile"),
    ),

      body: Center(child:
      StreamBuilder<DocumentSnapshot>(
        stream: docRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Error...');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }
          if (!snapshot.hasData) {
            return const Text('No Data found');
          }
          DocumentSnapshot docSnapshot = snapshot.data!;
          String fieldData1 = (docSnapshot.get('name')).toString();
          String fieldData2 = (docSnapshot.get('email')).toString();
          String fieldData3 = (docSnapshot.get('phoneno')).toString();
          // editData['name'] = fieldData;

          return Center(
            child: (Column(crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.green,
                        ),
                      ), Text(
                        fieldData1,
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Container(

                            padding: EdgeInsets.all(9.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.green, // Customize the box color as needed
                            ),
                            child: Icon(
                              Icons.person, // Replace with your desired icon
                              color: Colors.white70, // Customize the icon color as needed
                            ),

                          ),
                          SizedBox(width: 10,),
                          Text(
                            fieldData1,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Container(

                            padding: EdgeInsets.all(9.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.green, // Customize the box color as needed
                            ),
                            child: Icon(
                              Icons.mail, // Replace with your desired icon
                              color: Colors.white70, // Customize the icon color as needed
                            ),

                          ),
                          SizedBox(width: 10,),
                          Text(
                            fieldData2,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Container(

                            padding: EdgeInsets.all(9.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.green, // Customize the box color as needed
                            ),
                            child: Icon(
                              Icons.phone, // Replace with your desired icon
                              color: Colors.white70, // Customize the icon color as needed
                            ),

                          ),
                          SizedBox(width: 10,),
                          Text(
                            fieldData3,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                        ],
                      ),
                      SizedBox(width: 8.0), // Adjust the spacing between the icon and text

                      SizedBox(height: 20),
                    ],
                  ),


                  SizedBox(height: 16.0),

                  // Text('Name: $fieldData1',style: TextStyle(fontSize: 34.0,
                  //    fontWeight: FontWeight.bold,),),
                  // Text('Email id:$fieldData2',style: TextStyle(color: Colors.purple,fontSize: 30),),
                  //Text(fieldData3,style: TextStyle(color: Colors.purple,fontSize: 40),),




                ])),
          );
        },
      ),
      ),
    );
  }}