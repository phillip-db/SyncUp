import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:syncup/widgets/sized_icon_button.dart';
import 'package:spotify/spotify.dart' as spotifyimport;
import 'package:spotify_sdk/spotify_sdk.dart';

bool _loading = false;
bool _connected = false;
final Logger _logger = Logger();
spotifyimport.SpotifyApi spotify;
String imageUri =
    'spotify:image:ab67616d0000b2736b4f6358fbf795b568e7952d'; //default value
double playbackPercent = 0;

class MusicScreenTest extends StatefulWidget {
  static String route = "musicscreentest";

  @override
  _MusicScreenTestState createState() => _MusicScreenTestState();
}

/*
_currentlyPlaying(SpotifyApi spotify) async {
  await spotify.me.currentlyPlaying().then((a) {
    if (a == null) {
      return null;
    }
    return a.item.name;
  }).catchError(_prettyPrintError);
}
*/

class _MusicScreenTestState extends State<MusicScreenTest> {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    spotify = arguments['spotify'] as spotifyimport.SpotifyApi;
    return MaterialApp(
      title: 'Music Screen Test',
      home: StreamBuilder<ConnectionStatus>(
        stream: SpotifySdk.subscribeConnectionStatus(),
        builder: (context, snapshot) {
          _connected = false;
          if (snapshot.data != null) {
            _connected = snapshot.data.connected;
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Music Screen Test'),
            ),
            body: Container(
                child: Center(
              child: Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.all(8),
                    children: [
                      _connected
                          ? playerStateWidget()
                          : const Center(
                              child: Text('Not connected'),
                            ),
                      const Divider(),
                      _connected
                          ? spotifyImageWidget()
                          : const Text('Connect to see an image...'),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedIconButton(
                              width: 50,
                              icon: Icons.skip_previous,
                              onPressed: () {
                                setState(() {
                                  skipPrevious();
                                });
                              }),
                          SizedIconButton(
                              width: 50,
                              icon: Icons.play_arrow,
                              onPressed: () {
                                setState(() {
                                  resume();
                                });
                              }),
                          SizedIconButton(
                              width: 50,
                              icon: Icons.pause,
                              onPressed: () {
                                setState(() {
                                  pause();
                                });
                              }),
                          SizedIconButton(
                              width: 50,
                              icon: Icons.skip_next,
                              onPressed: () {
                                setState(() {
                                  skipNext();
                                });
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedIconButton(
                              width: 50,
                              icon: Icons.queue_music,
                              onPressed: () {
                                setState(() {
                                  queue();
                                });
                              }),
                          SizedIconButton(
                              width: 50,
                              icon: Icons.play_circle_filled,
                              onPressed: () {
                                setState(() {
                                  play();
                                });
                              }),
                          SizedIconButton(
                              width: 50,
                              icon: Icons.repeat,
                              onPressed: () {
                                setState(() {
                                  toggleRepeat();
                                });
                              }),
                          SizedIconButton(
                              width: 50,
                              icon: Icons.shuffle,
                              onPressed: () {
                                setState(() {
                                  toggleShuffle();
                                });
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton(
                              child: const Text('seek to'),
                              onPressed: () {
                                setState(() {
                                  seekTo();
                                });
                              }),
                          FlatButton(
                              child: const Text('seek to relative'),
                              onPressed: () {
                                setState(() {
                                  seekToRelative();
                                });
                              }),
                        ],
                      ),
                    ],
                  ),
                  _loading
                      ? Container(
                          color: Colors.black12,
                          child:
                              const Center(child: CircularProgressIndicator()))
                      : const SizedBox(),
                ],
              ),
            )),
          );
        },
      ),
    );
  }
}

Widget playerStateWidget() {
  return StreamBuilder<PlayerState>(
    stream: SpotifySdk.subscribePlayerState(),
    initialData: PlayerState(
      null,
      1,
      1,
      null,
      null,
      isPaused: false,
    ),
    // ignore: missing_return
    builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
      if (snapshot.data != null && snapshot.data.track != null) {
        var playerState = snapshot.data;
        imageUri = playerState.track.imageUri.raw;
        playbackPercent =
            playerState.playbackPosition / playerState.track.duration;
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('''
                    ${playerState.track.name} 
                    ${playerState.track.artist.name} 
                    ${playerState.track.album.name} '''),
            ],
          ),
        );
      } else {
        return Container(width: 0.0, height: 0.0);
      }
    },
  );
}

Widget spotifyImageWidget() {
  return FutureBuilder(
      future: SpotifySdk.getImage(
          imageUri: ImageUri(imageUri), dimension: ImageDimension.large),
      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
        if (snapshot.hasData) {
          imageCache.clear();
          return Image.memory(snapshot.data, gaplessPlayback: true);
        } else if (snapshot.hasError) {
          setStatus(snapshot.error.toString());
          return SizedBox(
            width: ImageDimension.large.value.toDouble(),
            height: ImageDimension.large.value.toDouble(),
            child: const Center(child: Text('Error getting image')),
          );
        } else {
          return SizedBox(
            width: ImageDimension.large.value.toDouble(),
            height: ImageDimension.large.value.toDouble(),
            child: const Center(child: Text('Getting image...')),
          );
        }
      });
}

Future getPlayerState() async {
  try {
    return await SpotifySdk.getPlayerState();
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

//not implemented
Future<void> queue() async {
  try {
    await SpotifySdk.queue(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> toggleRepeat() async {
  try {
    await SpotifySdk.toggleRepeat();
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> setRepeatMode(RepeatMode repeatMode) async {
  try {
    await SpotifySdk.setRepeatMode(
      repeatMode: repeatMode,
    );
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> setShuffle({bool shuffle}) async {
  try {
    await SpotifySdk.setShuffle(
      shuffle: shuffle,
    );
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> toggleShuffle() async {
  try {
    await SpotifySdk.toggleShuffle();
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

//not implemented
Future<void> play() async {
  try {
    await SpotifySdk.play(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> pause() async {
  try {
    await SpotifySdk.pause();
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> resume() async {
  try {
    await SpotifySdk.resume();
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> skipNext() async {
  try {
    await SpotifySdk.skipNext();
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> skipPrevious() async {
  try {
    await SpotifySdk.skipPrevious();
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> seekTo() async {
  try {
    await SpotifySdk.seekTo(positionedMilliseconds: 20000);
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> seekToRelative() async {
  try {
    await SpotifySdk.seekToRelativePosition(relativeMilliseconds: 20000);
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

void setStatus(String code, {String message = ''}) {
  var text = message.isEmpty ? '' : ' : $message';
  _logger.d('$code$text');
}

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    //actions for app bar
    return [IconButton(icon: Icon(Icons.clear), onPressed: () {})];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {});
  }

  @override
  Widget buildResults(BuildContext context) {
    //show some result based on the selection
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something
  }
}
