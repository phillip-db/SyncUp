import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'spotify_api_test.dart';
import '../main.dart';

class MusicScreenTest extends StatefulWidget {
  static String route = "musicscreentest";

  @override
  _MusicScreenTestState createState() => _MusicScreenTestState();
}

void _prettyPrintError(Exception error) {
  if (error is SpotifyException) {
    print('${error.status} : ${error.message}');
  } else {
    print(error);
  }
}

_currentlyPlaying(SpotifyApi spotify) async {
  await spotify.me.currentlyPlaying.then((a) {
    if (a == null) {
      return null;
    }
    return a.item.name;
  }).catchError(_prettyPrintError);
}

class _MusicScreenTestState extends State<MusicScreenTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Screen Test'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [],
          ),
        ),
      ),
    );
  }
}
