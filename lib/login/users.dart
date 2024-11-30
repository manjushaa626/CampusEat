import 'package:flutter/material.dart';

class users extends StatefulWidget {
  const users({Key? key}) : super(key: key);

  @override
  State<users> createState() => _usersState();
}

class _usersState extends State<users> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                  child: Column(
                    children: [
                      Text('Customer',style: TextStyle(color: Colors.white),),
                      Text('Restaurant',style: TextStyle(color: Colors.white),),
                      Text('Delivery Boy',style: TextStyle(color: Colors.white),)
                    ],
                  ))
            ]),
      ),
    );
  }
}