import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class paymentdetails extends StatelessWidget {
  const paymentdetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Payment Details'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('order_details').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            final orderDetails = snapshot.data!.docs;

            return ListView.builder(
              itemCount: orderDetails.length,
              itemBuilder: (context, index) {
                final order = orderDetails[index];
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('order_details').doc(order.id).get(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return SizedBox(); // No data found, return an empty widget
                    }
                    Map<String, dynamic> orderData = snapshot.data!.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text('Payment ID: ${order.id}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text('Customer Name: ${orderData['customerName']}'),
                          Text('Item Name: ${orderData['itemName']}'),
                          Text('Payment amount: ${orderData['price']}'),
                          // Text('Customer Phone: ${orderData['customerPhone']}'),
                          // Add more details as needed
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        )

    );
  }
}