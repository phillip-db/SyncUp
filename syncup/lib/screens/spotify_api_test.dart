// Copyright (c) 2017, 2020 rinukkusu, hayribakici. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:convert';
import 'package:spotify/spotify.dart';

import 'package:flutter/material.dart';

class SpotifyApiTest extends StatefulWidget {
  static String route = "spotifyapitest";
  static final credentials = SpotifyApiCredentials(
      "1278dc16cce24493bdf1e1101ec23c50", "d894b888bcaf4c8f880be8478d40b400");
  static final spotify = SpotifyApi(credentials);

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

class _SpotifyApiTestState extends State<SpotifyApiTest> {
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
            children: <Widget>[
              Text(artistName),
              Text(albumName),
              Text(albumList),
            ],
          ),
        ),
      ),
    );
  }
}
