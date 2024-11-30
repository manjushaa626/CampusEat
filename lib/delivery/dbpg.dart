import 'package:campuseat/delivery/deliveryOrderDetails.dart';
import 'package:campuseat/delivery/deliverypaymentdetails.dart';
import 'package:campuseat/login/loginpage.dart';
import 'package:campuseat/profile/profile.dart';
import 'package:campuseat/restaurant/orderdetails.dart';
import 'package:campuseat/restaurant/paymentdetails.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class dbpage extends StatefulWidget {
  const dbpage({Key? key}) : super(key: key);

  @override
  State<dbpage> createState() => _dbpageState();
}

class _dbpageState extends State<dbpage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white70,
      ),
      body: Center(
        child: Text('Welcome to CampusEats'),
      ),
    );
  }
}

class NavDrawer extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=>dbprofile()))},
          ),

          ListTile(
            leading: Icon(Icons.monetization_on_outlined),
            title: Text('Payment Details'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=>deliverypaymentdetails()))},
          ),

          ListTile(
            leading: Icon(Icons.menu_book),
            title: Text('Order Details'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=>deliveryorderdetails()))},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Signout'),
            onTap: () {
              auth.signOut().then((value) => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => loginpage(),
                  ),
                      (route) => false));
            },
          ),
        ],
      ),
    );
  }
}

