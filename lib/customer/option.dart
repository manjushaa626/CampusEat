import 'package:campuseat/payment/payment1.dart';
import 'package:campuseat/seatreservation/seatreservation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Option extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> item;

  Option(this.item);

  Future<String> fetchTableId() async {
    // Fetch the first document ID from the "Table" collection
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('Table').get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      return ''; // Return empty string if no documents found
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Restaurant Options'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Payment(data: item, orderType: 'Takeaway'),
                    ),
                  );
                  print('Takeaway selected');
                },
                child: Text('Takeaway'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String tableId = await fetchTableId();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyGrid(tableId: tableId, item: item, orderType: 'Seat Reservation'),
                    ),
                  );
                  print('Seat Reservation selected');
                },
                child: Text('Seat Reservation'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Payment(data: item, orderType: 'Delivery'),));
                   print('Delivery selected');
                },
                child: Text('Delivery'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
