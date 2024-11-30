import 'dart:async';
import 'package:campuseat/login/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
class homepage extends StatelessWidget {
  const homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    Timer(
        Duration(seconds: 4),
            () {
              if (auth.currentUser != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => loginpage(),
                  ),
                );
              }
              else {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => loginpage(),));
              }
            }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffe9b44c),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ Text("CampusEat",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 60,color: Colors.redAccent),),
            Text(
              'Welcome',
              style: TextStyle(fontSize: 30,color: Colors.black38),
            )
          ],
        ),
      ),
    );
  }
}
