import 'package:flutter/material.dart';
import 'tutorial_12.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Go to Tutorial 12'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Tutorial12()),
            );
          },
        ),
      ),
    );
  }
}
