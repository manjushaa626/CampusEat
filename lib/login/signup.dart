import 'package:campuseat/delivery/dbpg.dart';
import 'package:campuseat/login/loginpage.dart';
import 'package:campuseat/customer/custpg.dart';
import 'package:campuseat/restaurant/restpg.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';

var name ='';

class signuppgcust extends StatefulWidget {
  final role;
  const signuppgcust({Key? key, this.role}) : super(key: key);

  @override
  State<signuppgcust> createState() => _signuppgcustState();
}

class _signuppgcustState extends State<signuppgcust> {
  final CollectionReference user =
  FirebaseFirestore.instance.collection('User');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateUserData(
      String name,
      String phoneno,
      String email,
      String password,
      String role,
      ) async {
    return await user.doc(_auth.currentUser?.uid).set({
      'name': name,
      'phoneno': phoneno,
      'email': email,
      'password': password,
      'role': role
    });
  }

  void addUser() {
    updateUserData(nameTextController.text, phonenoTextController.text,
        emailController.text, passwordTextController.text, widget.role);
  }

  TextEditingController nameTextController = TextEditingController();
  TextEditingController phonenoTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? name;
  bool passwordvisible = true;
  bool agree = false;
  // String dropdownValue = 'CSE';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                    controller: nameTextController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.redAccent[100],
                      ),
                      hintText: "Name",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12)),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                    controller: phonenoTextController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.redAccent[100],
                      ),
                      hintText: "Phone no",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12)),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.redAccent[100],
                      ),
                      hintText: "Email id",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12)),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: 300,
                  child: TextField(
                    controller: passwordController,
                    obscureText: passwordvisible,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.redAccent[100],
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordvisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.redAccent[100],
                        ),
                        onPressed: () {
                          setState(() {
                            passwordvisible = !passwordvisible;
                          });
                        },
                      ),
                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.redAccent[100],
                      ),
                      suffixIcon: Icon(
                        Icons.remove_red_eye,
                        color: Colors.redAccent[100],
                      ),
                      hintText: "Confirm password",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12)),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      await _auth
                          .createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text)
                          .then(
                            (value) {
                          addUser();
                          print('Created New Account');
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => CustomerScreen()));
                        },
                      );
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => loginpage()));
                  },
                  child: Text("Login",style: TextStyle(color: Colors.black54),))
            ]),
      ),
    );
  }
}

class signuprest extends StatefulWidget {
  final role;
  const signuprest({Key? key, this.role}) : super(key: key);

  @override
  State<signuprest> createState() => _signuprestState();
}

class _signuprestState extends State<signuprest> {
  final CollectionReference user =
  FirebaseFirestore.instance.collection('User');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateUserData(
      String name,
      String phoneno,
      String email,
      String licenseno,
      String role,
      ) async {
    return await user.doc(_auth.currentUser?.uid).set({
      'name': name,
      'phoneno': phoneno,
      'email': email,
      'licenseno': licenseno,
      'role': role
    });
  }

  void addUser() {
    updateUserData(nameTextController.text, phonenoTextController.text,
        emailController.text, licensenoTextController.text,  widget.role.toString());
  }

  TextEditingController nameTextController = TextEditingController();
  TextEditingController phonenoTextController = TextEditingController();
  TextEditingController licensenoTextController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? name;
  bool passwordvisible = true;
  bool agree = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(controller: nameTextController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent)),
                        prefixIcon: Icon(
                          Icons.restaurant,
                          color: Colors.redAccent[100],
                        ),
                        hintText: "Restaurant Name",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12)),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 300,
                  child: TextField(controller: licensenoTextController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent)),
                        prefixIcon: Icon(
                          Icons.lock_person_outlined,
                          color: Colors.redAccent[100],
                        ),
                        hintText: "License No",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12)),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 300,
                  child: TextField(controller: phonenoTextController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent)),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.redAccent[100],
                        ),
                        hintText: "Contact No",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12)),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 300,
                  child: TextField(controller: emailController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent)),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.redAccent[100],
                        ),
                        hintText: "Email id",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12)),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: passwordvisible,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent)),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.redAccent[100],
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordvisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.redAccent[100],
                          ),
                          onPressed: () {
                            setState(() {
                              passwordvisible = !passwordvisible;
                            });
                          },
                        ),
                        hintText: "Password",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent)),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.redAccent[100],
                        ),
                        suffixIcon: Icon(
                          Icons.remove_red_eye,
                          color: Colors.redAccent[100],
                        ),
                        hintText: "Confirm password",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54)),
                      )),
                ),
                SizedBox(
                  height: 10,
                ), SizedBox(
                  width: 150,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () async {
          
                        await _auth
                            .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text)
                            .then(
                              (value) {
          
                            addUser();
                            print('Created New Account');
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => restpage()));
                          },
                        );
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => loginpage()));
                    },
                    child: Text("Login",style: TextStyle(color: Colors.black54),)),
          
              ]),
        ),
      ),
    );
  }
}

class signuppgdb extends StatefulWidget {
  final role;
  const signuppgdb({Key? key,this.role}) : super(key: key);

  @override
  State<signuppgdb> createState() => _signuppgdbState();
}

class _signuppgdbState extends State<signuppgdb> {
  final CollectionReference user =
  FirebaseFirestore.instance.collection('User');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateUserData(
      String name,
      String phoneno,
      String email,
      String password,
      String role,
      ) async {
    return await user.doc(_auth.currentUser?.uid).set({
      'name': name,
      'phoneno': phoneno,
      'email': email,
      'password': password,
      'role': role
    });
  }

  void addUser() {
    updateUserData(nameTextController.text, phonenoTextController.text,
        emailController.text, passwordTextController.text, widget.role);
  }

  TextEditingController nameTextController = TextEditingController();
  TextEditingController phonenoTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? name;
  bool passwordvisible = true;
  bool agree = false;
  // String dropdownValue = 'CSE';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                    controller: nameTextController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.redAccent[100],
                      ),
                      hintText: "Name",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12)),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                    controller: phonenoTextController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.redAccent[100],
                      ),
                      hintText: "Phone no",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12)),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.redAccent[100],
                      ),
                      hintText: "Email id",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12)),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: 300,
                  child: TextField(
                    controller: passwordController,
                    obscureText: passwordvisible,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.redAccent[100],
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordvisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.redAccent[100],
                        ),
                        onPressed: () {
                          setState(() {
                            passwordvisible = !passwordvisible;
                          });
                        },
                      ),
                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.redAccent[100],
                      ),
                      suffixIcon: Icon(
                        Icons.remove_red_eye,
                        color: Colors.redAccent[100],
                      ),
                      hintText: "Confirm password",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12)),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      await _auth
                          .createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text)
                          .then(
                            (value) {
                          addUser();
                          print('Created New Account');
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => dbpage()));
                        },
                      );
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => loginpage()));
                  },
                  child: Text("Login",style: TextStyle(color: Colors.black54),))
            ]),
      ),
    );
  }
}