// Copyright (c) 2017, 2020 rinukkusu, hayribakici. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:convert';
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

getArtistName() async {
  final credentials = SpotifyApiCredentials(
      "1278dc16cce24493bdf1e1101ec23c50", "d894b888bcaf4c8f880be8478d40b400");
  final spotify = SpotifyApi(credentials);
  var theArtist = await spotify.artists.get('5K4W6rqBFWDnAN6FQUkS6x');
  return theArtist.name;
}

getAlbumName() async {
  final credentials = SpotifyApiCredentials(
      "1278dc16cce24493bdf1e1101ec23c50", "d894b888bcaf4c8f880be8478d40b400");
  final spotify = SpotifyApi(credentials);
  var album = await spotify.albums.get('4Uv86qWpGTxf7fU7lG5X6F');
  return album.name;
}

getAlbumList() async {
  final credentials = SpotifyApiCredentials(
      "1278dc16cce24493bdf1e1101ec23c50", "d894b888bcaf4c8f880be8478d40b400");
  final spotify = SpotifyApi(credentials);
  var albumList =
      await spotify.albums.getTracks('4Uv86qWpGTxf7fU7lG5X6F').all();
  String concatList = "";
  albumList.forEach((track) {
    concatList += track.name + "\n";
  });
  return concatList;
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
  static final redirectUri = 'http://cs196.cs.illinois.edu/';

  //Small portion of scopes we can ask for during spotify authorization
  static final scopes = ['user-read-email', 'user-library-read'];

  static final authUri = grant.getAuthorizationUrl(
    Uri.parse(redirectUri),
    scopes: scopes, // scopes are optional
  );

  redirect(authUri) => setState(() {});

  static var responseUri = listenFunc(redirectUri);

  static final spotify = SpotifyApi.fromAuthCodeGrant(grant, responseUri);

  String albumName = "";
  String artistName = "";
  String albumList = "";

  _SpotifyApiTestState() {
    getAlbumName().then((val) => setState(() {
          albumName = val;
        }));

    getArtistName().then((val) => setState(() {
          artistName = val;
        }));

    getAlbumList().then((val) => setState(() {
          albumList = val;
        }));
  }

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
              SizedBox(
                width: 500.0,
                height: 500.0,
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
