// Copyright (c) 2017, 2020 rinukkusu, hayribakici. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:spotify/spotify.dart';

import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SpotifyApiTest extends StatefulWidget {
  static String route = "spotifyapitest";

  @override
  _SpotifyApiTestState createState() => _SpotifyApiTestState();
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
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
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
