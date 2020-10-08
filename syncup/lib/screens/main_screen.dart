import 'package:flutter/material.dart';
import '../main.dart';
import 'login_screen.dart';
import 'music_room.dart';

class MainScreen extends StatefulWidget {
  static String route = "main";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Main Screen"),
      ),
      body: Container(
        decoration: opacityBackground(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    LoginScreen.route,
                  );
                },
                child: Text('Go back!'),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    MusicRoom.route,
                  );
                },
                child: Text('Enter Room'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
