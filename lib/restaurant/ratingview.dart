import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../rating/rating.dart';
class RestaurantRatingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Ratings'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot> items = snapshot.data!.docs;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(items[index]['itemName']),
                subtitle: Text('Average Rating: ${items[index]['averageRating']}'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => RatingDialog(data: items[index]),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}