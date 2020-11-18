// Copyright (c) 2020 hayribakici. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:io';

import 'package:spotify/spotify.dart';

void main() async {
  var credentials = SpotifyApiCredentials(
      "1278dc16cce24493bdf1e1101ec23c50", "d894b888bcaf4c8f880be8478d40b400");
  var spotify = await _getUserAuthenticatedSpotifyApi(credentials);
  if (spotify == null) {
    exit(0);
  }
  _currentlyPlaying(spotify);
  _devices(spotify);

  exit(0);
}

Future<SpotifyApi> _getUserAuthenticatedSpotifyApi(
    SpotifyApiCredentials credentials) async {
  print(
      'Please paste your redirect url (from your spotify application\'s redirect url):');
  var redirect = "http://localhost:8888/callback";

  var grant = SpotifyApi.authorizationCodeGrant(credentials);
  var authUri = grant.getAuthorizationUrl(Uri.parse(redirect),
      scopes: ['user-read-playback-state']);

  print(
      'Please paste this url \n\n$authUri\n\nto your browser and enter the redirected url:');
  var redirectUrl;
  var userInput = stdin.readLineSync();
  if (userInput == null || (redirectUrl = Uri.tryParse(userInput)) == null) {
    print('Invalid redirect url');
    return null;
  }

  var client =
      await grant.handleAuthorizationResponse(redirectUrl.queryParameters);
  return SpotifyApi.fromClient(client);
}

void _currentlyPlaying(SpotifyApi spotify) async =>
    await spotify.me.currentlyPlaying().then((a) {
      if (a == null) {
        print('Nothing currently playing.');
        return;
      }
      print('Currently playing: ${a.item.name}');
    }).catchError(_prettyPrintError);

void _devices(SpotifyApi spotify) async =>
    await spotify.me.devices().then((devices) {
      if (devices == null) {
        print('No devices currently playing.');
        return;
      }
      print('Listing ${devices.length} available devices:');
      print(devices.map((device) => device.name).join(', '));
    }).catchError(_prettyPrintError);

void _prettyPrintError(Exception error) {
  if (error is SpotifyException) {
    print('${error.status} : ${error.message}');
  } else {
    print(error);
  }
}
