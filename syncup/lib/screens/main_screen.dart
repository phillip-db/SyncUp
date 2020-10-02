import 'package:flutter/material.dart';
import '../main.dart';
import 'login_screen.dart';

class MainScreen extends StatelessWidget {
  static String route = "main";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      body: Container(
        decoration: gradientBackground(),
        child: Center(
          child: RaisedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                LoginScreen.route,
              );
            },
            child: Text('Go back!'),
          ),
        ),
      ),
    );
  }
}
