import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class addToCart extends StatelessWidget {

  final String customerId;

  const addToCart({Key? key, required this.customerId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('cart')
              .doc(customerId)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Return a loading indicator while waiting for data
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Handle error state
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              var cartData = snapshot.data!.data();
              if (cartData != null && cartData is Map<String, dynamic>) {
                var items = cartData['items'] as List<dynamic>?; // Add '?' to indicate that 'items' can be null
                if (items != null) {
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index] as Map<String, dynamic>; // Cast 'item' to Map<String, dynamic>
                      return ListTile(
                        title: Text(item['itemName'] ?? ''), // Use null-aware operator '??' to handle null case
                        subtitle: Text('Price: ${item['price'] ?? ''}'), // Use null-aware operator '??' to handle null case
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text('No items in the cart'),
                  );
                }
              } else {
                return Center(
                  child: Text('Cart data is null or not of type Map<String, dynamic>'),
                );
              }
            }


          } ),
    );
  }
}