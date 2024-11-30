import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FAQScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('How do I place an order?'),
            subtitle: Text('Tap on the restaurant, choose your items, and proceed to checkout.'),
          ),
          ListTile(
            title: Text('What payment methods are accepted?'),
            subtitle: Text('We accept credit/debit cards, PayPal, and cash on delivery.'),
          ),
          ListTile(
            title: Text('How can I track my order?'),
            subtitle: Text('You can track your order in the "Orders" section of the app.'),
          ),
          ListTile(
            title: Text('I have a different question.'),
            subtitle: Text('Contact us directly by email.\nEmail Address:mainprojectgp17@gmail.com'),
          ),
        ],
      ),
    );
  }
}
