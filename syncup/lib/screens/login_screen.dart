import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'package:syncup/screens/main_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatelessWidget {
  static String route = "login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login'),
      ),
      body: Container(
        width: double.infinity,
        color: Colors.grey[800],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    width: MediaQuery.of(context).size.width * 0.2,
                    image: AssetImage('assets/images/song_placeholder.png'),
                  ),
                  Text(
                    'SyncUp',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                    textScaleFactor: 4.5,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: GestureDetector(
                onTap: () async {
                  const url = 'https://www.spotify.com';
                  if (await canLaunch(url)) {
                    await launch(url);
                    Navigator.pushNamed(context, MainScreen.route);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Image(
                    image: AssetImage('assets/images/spotify_logo.png'),
                  ),
                ),
              ),
            ),
            Text(
              'Log in with Spotify',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.13,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: new InkWell(
                child: new Text(
                  'By logging in, you agree to the SyncUp Terms of Service',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () async {
                  const url = 'http://cs196.cs.illinois.edu/';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
