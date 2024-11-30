import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final String category;
  final double amount;

  Payment(this.category, this.amount);
}

class Month extends StatefulWidget {
  const Month({Key? key}) : super(key: key);

  @override
  State<Month> createState() => _MonthState();
}

class _MonthState extends State<Month> {
  late List<String> days = []; // Initialize with an empty list
  late List<double> dailyEarnings = []; // Initialize with an empty list
  double totalDailyEarnings = 0.0;
  double monthlyEarnings = 0.0;
  double yearlyEarnings = 0.0;
  @override
  void initState() {
    super.initState();
    fetchDailyDetailsFromFirebase();
  }

  Future<void> fetchDailyDetailsFromFirebase() async {
    try {
      // Get the current date
      DateTime now = DateTime.now();
      String currentDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      // Fetch daily earnings for the current date
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('monthly_Earnings')
          .doc('user_id') // Assuming you have a user ID
          .collection('daily_earnings')
          .doc(currentDate)
          .get();

      setState(() async {
        if (snapshot.exists) {
          // If data exists for the current date, extract and update the state
          days = [currentDate]; // Set the current date as the only day
          dailyEarnings = [(snapshot.data() as Map<String, dynamic>)['amount']?.toDouble() ?? 0.0]; // Cast and retrieve amount for the current date
          totalDailyEarnings = dailyEarnings.first; // Set total daily earnings
          monthlyEarnings = await fetchMonthlyDetailsFromFirebase(); // Fetch monthly earnings
          yearlyEarnings = await fetchYearlyEarningsFromFirebase(); // Fetch yearly earnings
        } else {
          // If no data exists for the current date, set earnings to 0
          days = [];
          dailyEarnings = [0.0];
          totalDailyEarnings = 0.0;
          monthlyEarnings = await fetchMonthlyDetailsFromFirebase(); // Fetch monthly earnings
          yearlyEarnings = await fetchYearlyEarningsFromFirebase(); // Fetch yearly earnings
        }
      });

      print('Daily details fetched from Firebase successfully!');
    } catch (error) {
      print('Error fetching daily details from Firebase: $error');
    }
  }


// Function to fetch monthly earnings from Firebase Firestore
  Future<double> fetchMonthlyDetailsFromFirebase() async {
    try {
      // Query the collection containing monthly earnings
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('monthly_Earnings').doc('user_id').collection('monthly_earnings').get();

      // Calculate total monthly earnings by summing up all earnings
      double totalMonthlyEarnings = snapshot.docs.fold(0, (previous, current) => previous + current['amount']);

      return totalMonthlyEarnings;
    } catch (error) {
      print('Error fetching monthly earnings from Firebase: $error');
      return 0.0; // Return 0.0 in case of an error
    }
  }

  // Function to fetch yearly earnings from Firebase Firestore
  Future<double> fetchYearlyEarningsFromFirebase() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('monthly_Earnings')
          .doc('user_id')
          .collection('yearly_earnings')
          .get();

      // Calculate total yearly earnings by summing up all earnings
      double totalYearlyEarnings = snapshot.docs
          .fold(0, (previous, current) => previous + current['amount']);

      return totalYearlyEarnings;
    } catch (error) {
      print('Error fetching yearly earnings from Firebase: $error');
      return 0.0; // Return 0.0 in case of an error
    }
  }

  // Function to extract date from a timestamp string
  String _extractDate(String timestamp) {
    // Assuming timestamp is in ISO 8601 format, like "2024-04-01T12:34:56.789Z"
    return timestamp.split('T')[0];
  }

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty || dailyEarnings.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Monthly Earnings Chart"),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Monthly Earnings Chart"),
        ),
        body: Center(
          child: Container(
            width: 300,
            height: 200,
            child: CustomPaint(
              painter: LineChartPainter(
                  days, dailyEarnings,totalDailyEarnings, monthlyEarnings, yearlyEarnings),
            ),
          ),
        ),
      );
    }
  }
}

class LineChartPainter extends CustomPainter {
  final List<String> days;
  final List<double> dailyEarnings;
  final double totalDailyEarnings;
  final double monthlyEarnings;
  final double yearlyEarnings;


  LineChartPainter(
      this.days, this.dailyEarnings, this.totalDailyEarnings,this.monthlyEarnings, this.yearlyEarnings);

  @override
  void paint(Canvas canvas, Size size) {
    if (days.isEmpty || dailyEarnings.isEmpty) {
      // If either list is empty, return without painting anything
      return;
    }
    final double width = size.width;
    final double height = size.height;
    final double marginLeft = 30;
    final double marginTop = 10;
    final double marginRight = 10;
    final double marginBottom = 30;

    final Paint linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0;

    final double xInterval =
        (width - marginLeft - marginRight) / (days.length - 1);
    final double yInterval = (height - marginTop - marginBottom) /
        (dailyEarnings
                .reduce((value, element) => value > element ? value : element) +
            5);

    // Draw X-axis
    canvas.drawLine(Offset(marginLeft, height - marginBottom),
        Offset(width - marginRight, height - marginBottom), linePaint);

    // Draw Y-axis
    canvas.drawLine(Offset(marginLeft, marginTop),
        Offset(marginLeft, height - marginBottom), linePaint);

    // Draw X-axis label
    TextPainter(
      text: TextSpan(
        text: 'Date',
        style: TextStyle(color: Colors.black),
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout()
      ..paint(canvas, Offset(width / 2 - 10, height - marginBottom + 5));

    // Draw Y-axis label
    final yLabelPainter = TextPainter(
      text: TextSpan(
        text: 'Earnings',
        style: TextStyle(color: Colors.black),
      ),
      textDirection: TextDirection.ltr,
    );
    yLabelPainter.layout();
    yLabelPainter.paint(canvas, Offset(5, marginTop));

    // Draw grid lines
    for (int i = 0; i < days.length; i++) {
      final double x = marginLeft + xInterval * i;
      canvas.drawLine(Offset(x, marginTop), Offset(x, height - marginBottom),
          Paint()..color = Colors.grey.withOpacity(0.5));
    }

    for (int i = 0; i < dailyEarnings.length; i++) {
      final double y = height - marginBottom - (dailyEarnings[i] * yInterval);
      canvas.drawLine(Offset(marginLeft, y), Offset(width - marginRight, y),
          Paint()..color = Colors.grey.withOpacity(0.5));
    }

    final List<Offset> points = [];

    for (int i = 0; i < days.length; i++) {
      final double x = marginLeft + xInterval * i;
      final double y = height - marginBottom - (dailyEarnings[i] * yInterval);

      points.add(Offset(x, y));

      // Draw data points
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = Colors.blue);

      // Draw X-axis labels
      final xLabelPainter = TextPainter(
        text: TextSpan(
          text: days[i],
          style: TextStyle(color: Colors.black),
        ),
        textDirection: TextDirection.ltr,
      );
      xLabelPainter.layout();
      xLabelPainter.paint(canvas,
          Offset(x - xLabelPainter.width / 2, height - marginBottom + 5));

      // Draw Y-axis labels
      final yValuePainter = TextPainter(
        text: TextSpan(
          text: dailyEarnings[i].toString(),
          style: TextStyle(color: Colors.black),
        ),
        textDirection: TextDirection.ltr,
      );
      yValuePainter.layout();
      yValuePainter.paint(
          canvas,
          Offset(marginLeft - yValuePainter.width - 5,
              y - yValuePainter.height / 2));
    }

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], linePaint);
    }
    // Print daily, monthly, and yearly earnings below the graph
    final textStyle = TextStyle(color: Colors.black, fontSize: 16);
    final dailyText =
        'Daily Earnings: \$${dailyEarnings.reduce((value, element) => value + element).toStringAsFixed(2)}';
    final monthlyText =
        'Monthly Earnings: \$${monthlyEarnings.toStringAsFixed(2)}';
    final yearlyText =
        'Yearly Earnings: \$${yearlyEarnings.toStringAsFixed(2)}';
    TextPainter(
      text: TextSpan(
        text: '$dailyText\n$monthlyText\n$yearlyText',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout(maxWidth: width)
      ..paint(canvas, Offset(0, height + 10));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
