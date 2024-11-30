import 'package:campuseat/rating/rating.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_web/razorpay_web.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Payment extends StatefulWidget {
  final data;
  final orderType; // New parameter to store the order type
  const Payment({Key? key, required this.data, required this.orderType}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late Razorpay razorpay;
  List<double> dailyEarnings = [0.0];
  List<double> monthlyEarnings = [0.0];
  List<double> yearlyEarnings = [0.0];

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, errorHandler);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, successHandler);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWalletHandler);
  }

  // Initialize Firebase
  void initializeFlutterFire() async {
    await Firebase.initializeApp();
  }

  void errorHandler(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.message!),
      backgroundColor: Colors.red,
    ));
  }

  void successHandler(PaymentSuccessResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.paymentId!),
      backgroundColor: Colors.green,
    ));

    // Update earnings
    updateEarnings(response.paymentId!, widget.data['price']);

    // Store earnings, transaction date, and payment ID in Firestore
    await saveEarningsAndDateToFirestore(response.paymentId!,widget.orderType);
  }

  void updateEarnings(String paymentId, double amount) {
    // Get today's date
    DateTime now = DateTime.now();

    // Update daily earnings
    FirebaseFirestore.instance
        .collection('monthly_Earnings')
        .doc('user_id') // Assuming you have a user authentication system
        .collection('daily_earnings')
        .doc(now.toIso8601String()) // Use ISO 8601 string as document ID
        .set({'amount': amount, 'payment_id': paymentId},
        SetOptions(merge: true));

    // Update monthly earnings
    String monthYearKey = '${now.month}-${now.year}';
    FirebaseFirestore.instance
        .collection('monthly_Earnings')
        .doc('user_id')
        .collection('monthly_earnings')
        .doc(monthYearKey)
        .set({'amount': FieldValue.increment(amount)}, SetOptions(merge: true));

    // Update yearly earnings
    FirebaseFirestore.instance
        .collection('monthly_Earnings')
        .doc('user_id')
        .collection('yearly_earnings')
        .doc('${now.year}')
        .set({'amount': FieldValue.increment(amount)}, SetOptions(merge: true));
  }

  Future<void> saveEarningsAndDateToFirestore(String paymentId, String orderType) async {
    DateTime now = DateTime.now();
    String userId = FirebaseAuth.instance.currentUser!.uid; // Assuming the user is authenticated
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('User').doc(userId).get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    String customerName = userData['name']; // Fetch customer's name from user data
    String customerPhone = userData['phoneno'];
    FirebaseFirestore.instance
        .collection('monthly_Earnings')
        .doc('user_id')
        .collection('transactions')
        .doc(paymentId)
        .set({
      'amount': widget.data['price'],
      'transaction_date': now,
    });
    FirebaseFirestore.instance
        .collection('order_details')
        .doc(paymentId)
        .set({
      'orderType': widget.orderType,
      'itemName': widget.data['itemName'], // Add item name to the document
      'price': widget.data['price'], // Add price of the item to the document
      'customerName': customerName, // Add customer's name to the document
      'customerPhone': customerPhone, // Add customer's phone number to the document
      'transaction_date': now,
      // Add other relevant information here
    });
    // Store the date in a separate collection
    await FirebaseFirestore.instance
        .collection('monthly_Earnings')
        .doc('user_id')
        .collection('dates')
        .doc(now.toIso8601String()) // Use ISO 8601 string as document ID
        .set({
      'transaction_date': now,
    });
  }


  void externalWalletHandler(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.walletName!),
      backgroundColor: Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Razorpay")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.data['price'].toString()),
            ),
            const SizedBox(
              height: 20,
            ),
            // Text(dailyEarnings.toString()),
            // Text(monthlyEarnings.toString()),
            // Text(yearlyEarnings.toString()),
            MaterialButton(
              onPressed: () {
                openCheckout();
                Future.delayed(Duration(seconds: 4), () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RatingDialog(data: widget.data)));
                });
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                child: Text("Pay now"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openCheckout() {
    var options = {
      "key": "rzp_test_cyflIycUzeG9cJ",
      "amount": widget.data['price'] * 100,
      "name": "test",
      "description": " this is the test payment",
      "timeout": "180",
      "currency": "INR",
      "prefill": {
        "contact": "11111111111",
        "email": "test@abc.com",
      }
    };

    razorpay.open(options);
    // InkWell(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>RatingDialog()));});
  }
}