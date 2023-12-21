import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 60.0, horizontal: 40.0),
        child: Text(
          'Welcome to Home Page',
          style: TextStyle(fontSize: 40.0, color: Colors.blue),
        ),
      ),
    );
  }
}
