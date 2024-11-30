import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class RatingDialog extends StatefulWidget {

  final DocumentSnapshot data;
  const RatingDialog({Key? key, required this.data}) : super(key: key);
  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double _rating = 0;
  final TextEditingController _itemNameController = TextEditingController();
  void _submitRating() async {
    final itemDoc = FirebaseFirestore.instance.collection('items').doc(widget.data['itemName']);

    // Fetch current ratings data
    final DocumentSnapshot itemSnapshot = await itemDoc.get();
   // final double currentRating = itemSnapshot.get('rating') ?? 0;
    //final double currentRating = double.parse(itemSnapshot.get('rating') ?? '0');
    final dynamic ratingData = itemSnapshot.get('rating');
    final double currentRating = (ratingData is double || ratingData is int)
        ? ratingData.toDouble()
        : 0.0;
    final int ratingCount = itemSnapshot.get('ratingCount') ?? 0;

    // Calculate new average rating
    final double newTotalRating = currentRating + _rating;
    final int newRatingCount = ratingCount + 1;
    final String newAverageRating = (newTotalRating / newRatingCount).toStringAsFixed(2);

// If you need it as a double, you can parse it back
    final double newAverageRatingDouble = double.parse(newAverageRating);

    // Update item document with new rating data
    await itemDoc.update({
      'rating': newTotalRating,
      'ratingCount': newRatingCount,
      'averageRating': newAverageRating,
      'newAverageRatingDouble':newAverageRatingDouble,
    });

    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rate this item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(_rating >= 1 ? Icons.star : Icons.star_border),
                onPressed: () {
                  setState(() {
                    _rating = 1;
                  });
                },
              ),
              IconButton(
                icon: Icon(_rating >= 2 ? Icons.star : Icons.star_border),
                onPressed: () {
                  setState(() {
                    _rating = 2;
                  });
                },
              ),
              IconButton(
                icon: Icon(_rating >= 3 ? Icons.star : Icons.star_border),
                onPressed: () {
                  setState(() {
                    _rating = 3;
                  });
                },
              ),
              IconButton(
                icon: Icon(_rating >= 4 ? Icons.star : Icons.star_border),
                onPressed: () {
                  setState(() {
                    _rating = 4;
                  });
                },
              ),
              IconButton(
                icon: Icon(_rating >= 5 ? Icons.star : Icons.star_border),
                onPressed: () {
                  setState(() {
                    _rating = 5;
                  });
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _submitRating,
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
