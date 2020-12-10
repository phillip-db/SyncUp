import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:spotify/spotify.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:syncup/screens/main_screen.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SpotifyApiTest extends StatefulWidget {
  static String route = "spotifyapitest";

  @override
  _SpotifyApiTestState createState() => _SpotifyApiTestState();
}

Future<Map<String, dynamic>> backendTest() async {
  final response = await http.get(
      'https://delete-miz39.ondigitalocean.app/room/modify?roomname=gamerroom');
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load room');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({this.userId, this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

_connectToSpotify(clientId, redirectUri) async {
  await SpotifySdk.connectToSpotifyRemote(
      clientId: clientId, redirectUrl: redirectUri);
}

Future<Album> fetchAlbum() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/albums/1');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

/*
class Spotify {
  final String clientId;
  final String clientSecret;
  final String redirectUri;

  Spotify({this.clientId, this.clientSecret, this.redirectUri});

  factory Spotify.fromJson(Map<String, dynamic> json) {
    return Spotify(
      clientId: json['clientId'],
      clientSecret: json['clientSecret'],
      redirectUri: json['redirectUri'],
    );
  }
}
*/

redirect(authUri) async {
  if (await canLaunch(authUri)) {
    await launch(authUri);
  }
}

class _SpotifyApiTestState extends State<SpotifyApiTest> {
  //Future<Spotify> futureSpotifyData;
  Future<Album> futureAlbum;
  SpotifyApi spotify;
  Future<Map<String, dynamic>> songs;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

//Load data from json file
  /*
  String clientId;
  String clientSecret;
  String theRedirectUri;
  */

  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    futureAlbum = fetchAlbum();
    songs = backendTest();
    //futureSpotifyData = fetchSpotifyData();
  }

  static final clientId = "1278dc16cce24493bdf1e1101ec23c50";
  static final clientSecret = "d894b888bcaf4c8f880be8478d40b400";
  static final theRedirectUri = "http://localhost:8888/callback/";

  static final credentials = SpotifyApiCredentials(clientId, clientSecret);

  static final grant = SpotifyApi.authorizationCodeGrant(credentials);
  static final redirectUri = theRedirectUri;

  //Small portion of scopes we can ask for during spotify authorization
  static final scopes = ['user-read-email', 'user-library-read'];

  static final authUri = grant.getAuthorizationUrl(
    Uri.parse(redirectUri),
    scopes: scopes, // scopes are optional
  );

  var responseUri;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /*
              Container(
                height: 50,
                child: FutureBuilder<Album>(
                  future: futureAlbum,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text("Http Test Title: ${snapshot.data.title}");
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                ),
              ),
              */
              /*
              Container(
                child: FutureBuilder<Map<String, dynamic>>(
                  future: songs,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<String> songList = [];
                      snapshot.data.forEach((key, value) {
                        songList.add("$key: $value");
                      });
                      return Text("Backend Test - ${songList.toString()}");
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                ),
              ),
              */
              /*
              FutureBuilder<Spotify>(
                  future: futureSpotifyData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      clientId = snapshot.data.clientId;
                      clientSecret = snapshot.data.clientSecret;
                      theRedirectUri = snapshot.data.redirectUri;

                      credentials =
                          SpotifyApiCredentials(clientId, clientSecret);

                      grant = SpotifyApi.authorizationCodeGrant(credentials);
                      redirectUri = theRedirectUri;

                      //Small portion of scopes we can ask for during spotify authorization
                      scopes = ['user-read-email', 'user-library-read'];

                      authUri = grant.getAuthorizationUrl(
                        Uri.parse(redirectUri),
                        scopes: scopes, // scopes are optional
                      );
                    }
                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  }),
                  */
              Expanded(
                child: WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: authUri.toString(),
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                    navigationDelegate: (navReq) {
                      if (navReq.url.startsWith(redirectUri)) {
                        responseUri = navReq.url;
                        // ignore: unused_local_variable
                        SpotifySdk.connectToSpotifyRemote(
                            clientId: clientId, redirectUrl: redirectUri);
                        var authenticationToken = SpotifySdk.getAuthenticationToken(
                            clientId: clientId,
                            redirectUrl: redirectUri,
                            scope: 'app-remote-control, '
                                'user-modify-playback-state, '
                                'playlist-read-private, '
                                'playlist-modify-public,user-read-currently-playing');
                        spotify =
                            SpotifyApi.fromAuthCodeGrant(grant, responseUri);
                        //String json = jsonEncode(spotify);
                        Navigator.pushNamed(context, MainScreen.route,
                            arguments: {'spotify': spotify});
                        return NavigationDecision.prevent;
                      } else {
                        return NavigationDecision.navigate;
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
