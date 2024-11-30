import 'package:campuseat/payment/payment1.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

void clearBookingCollection() async {
  try {
    // Get the current time
    DateTime currentTime = DateTime.now();

    // Check if the current time is after 12 AM
    if (currentTime.hour >= 0 && currentTime.hour < 12) {
      // Clear all documents from the 'booking' collection
      WriteBatch batch = FirebaseFirestore.instance.batch();
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('bookings').get();
      querySnapshot.docs.forEach((doc) {
        batch.delete(doc.reference);
      });
      await batch.commit();
      print('All documents in the "booking" collection cleared.');
    } else {
      print('Current time is not after 12 AM. No action taken.');
    }
  } catch (e) {
    print('Error clearing booking collection: $e');
  }
}
void main() {
  // Run the function immediately when the server starts
  clearBookingCollection();

  // Set up a scheduled trigger to run the function daily at midnight
  // This scheduling depends on the environment you are deploying your function
  // For Firebase Cloud Functions, you can use a cron job scheduler
  // For example, you can deploy this function to Firebase Cloud Functions and set up a cron job trigger in your function configuration
}

class MyGrid extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> item;
  final String tableId;
  final String orderType; // Add orderType parameter

  MyGrid({required this.tableId, required this.item, required this.orderType}); // Update constructor

  @override
  _MyGridState createState() => _MyGridState();
}

class _MyGridState extends State<MyGrid> {
  int documentCount = 0;
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDocumentCount();
  }

  Future<void> fetchDocumentCount() async {
    int count = await getDocumentCount('Table');
    setState(() {
      documentCount = count;
    });
  }

  Future<int> getDocumentCount(String collectionPath) async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(collectionPath).get();

    return querySnapshot.size;
  }

  Future<bool> checkBookingConflicts(
      List<int> selectedIndices, String startTime, String endTime) async {
    try {
      print('Checking for booking conflicts...');
      DateTime currentDate = DateTime.now();

      DateTime startDateTime = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        int.parse(startTime.split(':')[0]),
        int.parse(startTime.split(':')[1]),
      );
      DateTime endDateTime = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        int.parse(endTime.split(':')[0]),
        int.parse(endTime.split(':')[1]),
      );

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('bookings')
         // .where('booking_date', isEqualTo: currentDate)
          .get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        int tableNumber = docSnapshot['table_number'];
        if (selectedIndices.contains(tableNumber - 1)) {
          String existingStartTimeString = docSnapshot['start_time'];
          String existingEndTimeString = docSnapshot['end_time'];
          DateTime existingStartTime = DateTime.parse(existingStartTimeString);
          DateTime existingEndTime = DateTime.parse(existingEndTimeString);

          if ((startDateTime.isBefore(existingEndTime) && endDateTime.isAfter(existingStartTime)) ||
              (startDateTime == existingStartTime && endDateTime == existingEndTime) ||
              (startDateTime.isAfter(existingStartTime) && startDateTime.isBefore(existingEndTime)) ||
              (endDateTime.isAfter(existingStartTime) && endDateTime.isBefore(existingEndTime))) {
            print('Conflict detected!');
            return true;
          }
        }
      }

      print('No conflicts found.');
      return false;
    } catch (e) {
      print('Error checking booking conflicts: $e');
      return true; // Consider this as a conflict for simplicity
    }
  }




  bool isAddingSeat = false; // Track whether "Add Seat" button is pressed
  List<int> selectedIndices =
  []; // Track selected indices when "Add Seat" is pressed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('Table')
              .doc(widget.tableId)
              .get(), // Replace 'table_id' with the ID of the table you want to fetch
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              Map<String, dynamic> tableData =
              snapshot.data!.data() as Map<String, dynamic>;
              String numberOfSeats = tableData['number_of_seats'].toString();
              String description = tableData['description'].toString();

              return Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // Toggle the flag when "Add Seat" button is pressed
                            isAddingSeat = !isAddingSeat;
                            if (!isAddingSeat) {
                              // Clear selected indices when "Add Seat" is not pressed
                              selectedIndices.clear();
                            }
                          });
                        },
                        child: Text(isAddingSeat ? 'Cancel' : 'Add Seat'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // Check for booking conflicts
                          bool hasConflict = await checkBookingConflicts(
                            selectedIndices,
                            startTimeController.text,
                            endTimeController.text,
                          );

                          if (hasConflict) {
                            // Provide feedback to the user about the conflict
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Booking Conflict'),
                                content: Text(
                                    'There is a booking conflict. Please select a different time slot or table.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // Navigate to the next page (Payment) only if there is no conflict
                            for (int selectedIndex in selectedIndices) {
                              await FirebaseFirestore.instance
                                  .collection('bookings')
                                  .add({
                                'table_number': selectedIndex +
                                    1, // Assuming table numbers start from 1
                                'start_time': startTimeController.text,
                                'end_time': endTimeController.text,
                                'booking_date': DateTime
                                    .now(), // Assuming you want to store the booking date as well
                              });
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Payment(data: widget.item,orderType: widget.orderType,),
                              ),
                            );
                            // Handle payment button press
                            print('Payment button pressed');
                          }
                        },
                        child: Text('Payment'),
                      ),
                    ],
                  ),
                  // Row for booking time selection
                  Row(
                    children: [
                      Text('Start Time: '),
                      SizedBox(width: 10),
                      // Text field for entering start time
                      Flexible(
                        child: TextFormField(
                          controller: startTimeController,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            hintText: 'Enter start time',
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Text('End Time: '),
                      SizedBox(width: 10),
                      // Text field for entering end time
                      Flexible(
                        child: TextFormField(
                          controller: endTimeController,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            hintText: 'Enter end time',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 30.0,
                          mainAxisSpacing: 30.0,
                        ),
                        itemCount: documentCount,
                        itemBuilder: (BuildContext context, int index) {
                          return FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('Table')
                                .where('table_number',
                                isEqualTo: index +
                                    1) // Assuming table numbers start from 1
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (snapshot.data!.docs.isEmpty) {
                                return Tooltip(
                                  message: 'Table ${index + 1} not available',
                                  child: ElevatedButton(
                                    onPressed:
                                        () {}, // Disable the button as there's no data
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.grey,
                                      onPrimary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Table ${index + 1}',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                QueryDocumentSnapshot<Object?> tableSnapshot =
                                    snapshot.data!.docs.first;
                                String numberOfSeats =
                                tableSnapshot['number_of_seats'].toString();
                                String description =
                                tableSnapshot['description'].toString();

                                return Tooltip(
                                  message:
                                  'Number of Seats: $numberOfSeats\nDescription: $description',
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        // Allow multiple selections only when "Add Seat" is pressed
                                        if (isAddingSeat) {
                                          if (selectedIndices.contains(index)) {
                                            selectedIndices.remove(index);
                                          } else {
                                            selectedIndices.add(index);
                                          }
                                        } else {
                                          // Single selection when "Add Seat" is not pressed
                                          selectedIndices.clear();
                                          selectedIndices.add(index);
                                        }
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: selectedIndices.contains(index)
                                          ? Colors.redAccent
                                          : Colors.black12,
                                      onPrimary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Table ${index + 1}',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
