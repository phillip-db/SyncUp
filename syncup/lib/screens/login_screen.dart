import 'package:flutter/material.dart';
import 'package:syncup/screens/spotify_api_test.dart';
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
            LogoText(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            LoginButton(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.13,
            ),
            TermsOfService(),
          ],
        ),
      ),
    );
  }
}

/// Text containing Terms of Service
class TermsOfService extends StatelessWidget {
  const TermsOfService({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: new InkWell(
        child: new Text(
          'By logging in, you agree to the SyncUp Terms of Service',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
        onTap: () async {
          const url = 'http://cs196.cs.illinois.edu/'; //temporary
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
      ),
    );
  }
}

/// Button that prompts user to login with their Spotify account
class LoginButton extends StatelessWidget {
  const LoginButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, SpotifyApiTest.route);
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                children: [
                  Image(
                    image: AssetImage('assets/images/spotify_logo.png'),
                  ),
                  Text(
                    'Log in with Spotify',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Container that includes SyncUp logo and text
class LogoText extends StatelessWidget {
  const LogoText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            width: MediaQuery.of(context).size.width * 0.15,
            height: MediaQuery.of(context).size.height * 0.2,
            image: AssetImage('assets/images/syncup_logo.png'),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
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
    );
  }
}
