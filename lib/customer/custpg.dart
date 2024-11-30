import 'package:campuseat/customer/addtocart.dart';
import 'package:campuseat/customer/help.dart';
import 'package:campuseat/customer/option.dart';
import 'package:campuseat/customer/orderhistory.dart';
import 'package:campuseat/login/homepage.dart';
import 'package:campuseat/login/loginpage.dart';
import 'package:campuseat/payment/payment1.dart';
import 'package:campuseat/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'option.dart';

import '../Recommentation/recommentation.dart';

class CustomerScreen extends StatelessWidget {

  void navigateToViewItem(BuildContext context, QueryDocumentSnapshot<Object?> item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => viewitem(item)),
    );
  }
  String? customerId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('CampusEats'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to the cart page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => addToCart(customerId: '$customerId'),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('items')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          final foodItems = snapshot.data!.docs;
          return ListView.builder(
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              final item = foodItems[index];
              return  InkWell(
                onTap:()=> navigateToViewItem(context,item),
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white, // You can set the color of the border
                        width: 2.0, // You can set the width of the border
                      )),
                  margin: EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Container(
                        child:
                        Image.network(
                          item['image'],
                          width: 300,
                          height:300,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['itemName'],
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                                'Price: ${item['price']}'),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              );
            },
          );
        },
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
          SizedBox(
            height: 30,
          ),

          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CustProfile()))
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Order History'),
            onTap: () => { Navigator.push(context,
                MaterialPageRoute(builder: (context) => orderhistory()))},
          ),
          ListTile(
            leading: Icon(Icons.recommend),
            title: Text('Recommendations'),
            onTap: () => { Navigator.push(context,
                MaterialPageRoute(builder: (context) => recommentation()))},
          ),
          ListTile(
            leading: Icon(Icons.location_on_outlined),
            title: Text('Order tracking'),

          ),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Help'),
            onTap: () => { Navigator.push(context,
                MaterialPageRoute(builder: (context) => FAQScreen()))
            },
          ),

          // ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Signout'),
            onLongPress: () {
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


class viewitem extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> item;
  viewitem(this.item);
  void addToCart(BuildContext context, QueryDocumentSnapshot<Object?> item) async {
    // Show pop-up message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item added to cart',style: TextStyle(color:Colors.white)),
        duration: Duration(seconds: 5),
      ),
    );

    // Get the current user's ID
    String customerId = FirebaseAuth.instance.currentUser!.uid;

    // Add the selected item details to the "cart" collection
    await FirebaseFirestore.instance.collection('cart').doc(customerId).set({
      'customerId': customerId,
      'items': FieldValue.arrayUnion([{
        'itemName': item['itemName'],
        'price': item['price'],
        // Add more item details as needed
      }])
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 500,
                padding: new EdgeInsets.all(10.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(item['image']),
                      Text(item['itemName'],style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                      Text(item['restaurantName'],style: TextStyle(fontSize: 18,color: Colors.black87),),
                      Text('Price: \$${item['price']}',style: TextStyle(color: Colors.grey,fontSize: 20),),

                    ],
                  ),
                ),

              ),
              Text('Rating: ${item['newAverageRatingDouble']}', style: TextStyle(fontSize: 17),),



              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: ()=> addToCart(context, item),
                      child: Text('Add to Cart')),
                  SizedBox(
                    width: 50,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,MaterialPageRoute(builder: (context)=>Option(item))
                          // MaterialPageRoute(
                          //     builder: (context) => payment(
                          //           data: item,
                          //         ))
                        );
                      },
                      child: Text('Order Now')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}