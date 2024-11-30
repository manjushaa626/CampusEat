import 'package:campuseat/customer/custpg.dart';
import 'package:campuseat/delivery/dbpg.dart';
import 'package:campuseat/login/forgotpassword.dart';
import 'package:campuseat/login/signup.dart';
import 'package:campuseat/login/users.dart';
import 'package:campuseat/customer/custpg.dart';
import 'package:campuseat/restaurant/restpg.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:campuseat/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class loginpage extends StatefulWidget {
  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {} catch (e) {}
  }

  loginpage({Key? key}) : super(key: key);
  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference user = FirebaseFirestore.instance.collection('User');
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passemble = true;
  //bool visible = false;
  var _emailController;
  @override
  Widget build(BuildContext context) {
    var _passwordController;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent)),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.redAccent[100],
                    ),
                    hintText: "Email id",
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12)),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                width: 300,
                child: TextField(
                  controller: passwordController,
                  obscureText: passemble,
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent)),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.redAccent[100],
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        passemble ? Icons.visibility : Icons.visibility_off,
                        color: Colors.redAccent[100],
                      ),
                      onPressed: () {
                        setState(() {
                          passemble = !passemble;
                        });
                      },
                    ),
                    hintText: "Password",
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                )),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () async {
                    await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text)
                        .then(
                          (value) async {
                        DocumentReference reference =
                        user.doc(_auth.currentUser?.uid);
                        DocumentSnapshot documentSnapshot =
                        await reference.get();
                        if (documentSnapshot.get('role') == "Customer")
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomerScreen()));
                        else
                        if (documentSnapshot.get('role') == "Restaurant") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const restpage()));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const dbpage()));
                        }
                      },
                    );
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            TextButton(
                onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordScreen()));},
                child: const Text(
                  "forgot password",
                  style: TextStyle(color: Colors.black38, fontSize: 15),
                )),
            TextButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: 400,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                 SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  width: 200,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.redAccent,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10))),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                     signuppgcust(
                                                      role: "Customer",
                                                    )));
                                      },
                                      child:  Text("Customer",style: TextStyle(color: Colors.white),)),
                                ),
                                 SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  width: 200,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.redAccent,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10))),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const signuprest(
                                                      role: "Restaurant",
                                                    )));
                                      },
                                      child: const Text("Restaurant",style: TextStyle(color: Colors.white),)),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  width: 200,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.redAccent,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10))),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const signuppgdb(
                                                      role: "Delivery boy",
                                                    )));
                                      },
                                      child: const Text("Delivery Boy",style: TextStyle(color: Colors.white),)),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
                child: const Text(
                  "Register Now",
                  style: TextStyle(color: Colors.black38, fontSize: 15),
                ))
          ],
        ),
      ),
    );
  }
}