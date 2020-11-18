import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:spotify/spotify.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SpotifyApiTest extends StatefulWidget {
  static String route = "spotifyapitest";

  @override
  _SpotifyApiTestState createState() => _SpotifyApiTestState();
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

redirect(authUri) async {
  if (await canLaunch(authUri)) {
    await launch(authUri);
  }
}

listenFunc(redirectUri) async {
  final linksStream = getLinksStream().listen((String link) async {
    if (link.startsWith(redirectUri)) {
      return link;
    }
  });
}

Future<String> _loadSpotifyAsset() async {
  return await rootBundle.loadString('assets/json/spotify_data.json');
}

loadSpotifyData() async {
  String jsonString = await _loadSpotifyAsset();
  final jsonResponse = jsonDecode(jsonString);
  return jsonResponse;
}

getClientId(List<dynamic> spotifyData) {
  return spotifyData[0];
}

List<dynamic> spotifyData = loadSpotifyData();
String clientId = spotifyData[0];
String clientSecret = spotifyData[1];
String redirectUri;

class _SpotifyApiTestState extends State<SpotifyApiTest> {
  Future<Album> futureAlbum;

  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    futureAlbum = fetchAlbum();
  }

  // These are HARDCODED Values of My Personal (Daniel Rugutt's) Spotify Client ID
  static final credentials = SpotifyApiCredentials(
      "1278dc16cce24493bdf1e1101ec23c50", "d894b888bcaf4c8f880be8478d40b400");
  static final grant = SpotifyApi.authorizationCodeGrant(credentials);
  static final redirectUri = 'http://localhost:8888/callback/';

  //Small portion of scopes we can ask for during spotify authorization
  static final scopes = ['user-read-email', 'user-library-read'];

  static final authUri = grant.getAuthorizationUrl(
    Uri.parse(redirectUri),
    scopes: scopes, // scopes are optional
  );

  redirect(authUri) => setState(() {});

  static var responseUri = listenFunc(redirectUri);

  static final spotify = SpotifyApi.fromAuthCodeGrant(grant, responseUri);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Spotify API Test'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              Expanded(
                child: WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: authUri.toString(),
                    navigationDelegate: (navReq) {
                      if (navReq.url.startsWith(redirectUri)) {
                        responseUri = navReq.url;
                        return NavigationDecision.prevent;
                      }
                      return NavigationDecision.navigate;
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
