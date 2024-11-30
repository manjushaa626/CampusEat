import 'package:campuseat/login/loginpage.dart';
import 'package:campuseat/profile/profile.dart';
import 'package:campuseat/restaurant/additem.dart';
import 'package:campuseat/restaurant/monthlyearnings.dart';
import 'package:campuseat/restaurant/orderdetails.dart';
import 'package:campuseat/restaurant/paymentdetails.dart';
import 'package:campuseat/restaurant/ratingview.dart';
import 'package:campuseat/restaurant/table.dart';
import 'package:campuseat/restaurant/updateitem.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class restpage extends StatefulWidget {
  const restpage({Key? key}) : super(key: key);

  @override
  State<restpage> createState() => _restpageState();
}

class _restpageState extends State<restpage> {

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white70,
      ),
      body: Center(
        child: Text('Welcome to CampusEats Application '),
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
            onTap: () => {Navigator.push(context,MaterialPageRoute(builder: (context)=>restprofile()))},
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add item'),
            onTap: () => {Navigator.push(context,MaterialPageRoute(builder: (context)=>additem()))},
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Update Item'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateItem()))},
          ),
          ListTile(
            leading: Icon(Icons.menu_book),
            title: Text('Order Details'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=>orderdetails()))},
          ),
          ListTile(
            leading: Icon(Icons.monetization_on_outlined),
            title: Text('Payment Details'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=>paymentdetails()))},
          ),
          ListTile(
            leading: Icon(Icons.stacked_line_chart),
            title: Text('Monthly Earnings'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=>Month()))},
          ),
          ListTile(
            leading: Icon(Icons.table_restaurant),
            title: Text('Update Seats'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp()))},
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('View rating'),
            onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context)=>RestaurantRatingPage()))},
          ),

          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Signout'),
            onTap: ()  {auth.signOut().then((value) => Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => loginpage(),), (route) => false));},
          ),
        ],
      ),
    );
  }
}
