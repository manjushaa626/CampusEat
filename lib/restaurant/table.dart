import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Table Booking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TableBookingPage(),
    );
  }
}

class TableBookingPage extends StatefulWidget {
  @override
  _TableBookingPageState createState() => _TableBookingPageState();
}

class _TableBookingPageState extends State<TableBookingPage> {
  final TextEditingController _totalTablesController = TextEditingController();

  List<int> _seatsPerTable = [];
  List<String> _tableDescriptions = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void _submitForm() {
    int totalTables;
    try {
      totalTables = int.parse(_totalTablesController.text);
    } catch (e) {
      totalTables = 0;
    }

    if (totalTables != null && totalTables > 0) {
      // Show text fields for number of seats and table descriptions
      setState(() {
        _seatsPerTable = List.generate(totalTables, (index) => 0);
        _tableDescriptions = List.generate(totalTables, (index) => '');
      });
    } else {
      // Show error dialog if totalTables is not valid
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter a valid number of tables.'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _saveData() {
    // Save data to Firestore
    for (int i = 0; i < _seatsPerTable.length; i++) {
      firestore.collection('Table').doc(_tableDescriptions[i]).set({
        'table_number': i + 1,
        'number_of_seats': _seatsPerTable[i],
        'description': _tableDescriptions[i],
      }).then((value) {
        // print('Table ${i + 1} added with ID: ${value.}');

      }).catchError((error) {
        print('Error adding table ${i + 1}: $error');
      });
      _seatsPerTable.removeAt(i);
      _tableDescriptions.removeAt(i);
      _totalTablesController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Table Booking'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _totalTablesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Total number of tables'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: _seatsPerTable.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        onChanged: (value) {
                          _seatsPerTable[index] = int.tryParse(value) ?? 0;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Number of seats for Table ${index + 1}',
                        ),
                      ),
                      TextField(
                        onChanged: (value) {
                          _tableDescriptions[index] = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Description for Table ${index + 1}',
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Save Data'),
            ),
          ],
        ),
      ),
    );
  }
}
