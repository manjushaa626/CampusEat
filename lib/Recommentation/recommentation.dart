import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class recommentation extends StatelessWidget {
  const recommentation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommendation Page'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('order_details').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          // Map to store the frequency of each item
          Map<String, int> itemFrequency = {};

          // Calculate item frequency
          snapshot.data!.docs.forEach((orderDoc) {
            Map<String, dynamic>? orderData = orderDoc.data() as Map<String, dynamic>?;

            if (orderData != null && orderData.containsKey('itemName') && orderData.containsKey('price')) {
              String itemName = orderData['itemName'];
              itemFrequency[itemName] = (itemFrequency[itemName] ?? 0) + 1;
            }
          });

          // Filter items ordered more than once
          List<String> frequentItems = [];
          itemFrequency.forEach((itemName, frequency) {
            if (frequency > 3) {
              frequentItems.add(itemName);
            }
          });

          if (frequentItems.isEmpty) {
            return Center(child: Text('No frequent items found'));
          }

          return ListView.builder(
            itemCount: frequentItems.length,
            itemBuilder: (context, index) {
              String itemName = frequentItems[index];
              return ListTile(
                title: Text(itemName),
                subtitle: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('order_details').where('itemName', isEqualTo: itemName).get().then((value) => value.docs[0]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox();
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return SizedBox();
                    }

                    Map<String, dynamic> itemData = snapshot.data!.data() as Map<String, dynamic>;
                    return Text('Price: ${itemData['price']}');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}