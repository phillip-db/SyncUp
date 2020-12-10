import 'package:flutter/material.dart';
import 'package:syncup/screens/spotify_api_test.dart';

class HomeScreen extends StatefulWidget {
  static String route = "home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text('Log in to Spotify'),
                onPressed: () {
                  Navigator.pushNamed(context, SpotifyApiTest.route);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
