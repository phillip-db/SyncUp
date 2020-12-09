import 'dart:io';
import 'dart:convert';
import 'package:spotify/spotify.dart';

part of spotify;

class Playlists extends EndpointPaging {
  @override
  String get _path => 'v1/browse';

  Playlists(SpotifyApiBase api) : super(api);

  Future<Playlist> get(String playlistId) async {
    return Playlist.fromJson(
        jsonDecode(await _api._get('v1/playlists/$playlistId')));
  }

  Pages<PlaylistSimple> get featured {
    return _getPages(
        '$_path/featured-playlists',
        (json) => PlaylistSimple.fromJson(json),
        'playlists',
        (json) => PlaylistsFeatured.fromJson(json));
  }

  Pages<PlaylistSimple> get me {
    return _getPages(
        'v1/me/playlists', (json) => PlaylistSimple.fromJson(json));
  }

  /// [playlistId] - the Spotify playlist ID
  Pages<Track> getTracksByPlaylistId(playlistId) {
    return _getPages('v1/playlists/$playlistId/tracks',
        (json) => Track.fromJson(json['track']));
  }

  /// [userId] - the Spotify user ID
  ///
  /// [playlistName] - the name of the new playlist
  Future<Playlist> createPlaylist(String userId, String playlistName) async {
    final url = 'v1/users/$userId/playlists';
    final playlistJson =
        await _api._post(url, jsonEncode({'name': playlistName}));
    return await Playlist.fromJson(jsonDecode(playlistJson));
  }

  /// [trackUri] - the Spotify track uri (i.e spotify:track:4iV5W9uYEdYUVa79Axb7Rh)
  ///
  /// [playlistId] - the playlist ID
  Future<Null> addTrack(String trackUri, String playlistId) async {
    final url = 'v1/playlists/$playlistId/tracks';
    await _api._post(
        url,
        jsonEncode({
          'uris': [trackUri]
        }));
  }

  /// [trackUris] - the Spotify track uris
  /// (i.e each list item in the format of "spotify:track:4iV5W9uYEdYUVa79Axb7Rh")
  ///
  /// [playlistId] - the playlist ID
  Future<Null> addTracks(List<String> trackUris, String playlistId) async {
    final url = 'v1/playlists/$playlistId/tracks';
    await _api._post(url, jsonEncode({'uris': trackUris}));
  }

  Future<Null> removeTrack(String trackUri, String playlistId,
      [List<int> positions]) async {
    final url = 'v1/playlists/$playlistId/tracks';
    final track = <String, dynamic>{'uri': trackUri};
    if (positions != null) {
      track['positions'] = positions;
    }

    final body = jsonEncode({
      'tracks': [track]
    });
    await _api._delete(url, body);
  }

  /// [country] - a country: an ISO 3166-1 alpha-2 country code. 
  /// [locale] - the desired language, consisting of an ISO 639-1 language code
  /// [categoryId] - the Spotify category ID for the category.
  Pages<PlaylistSimple> getByCategoryId(String categoryId,
      {String country, String locale}) {
    final query = _buildQuery({'country': country, 'locale': locale});

    return _getPages(
        '$_path/categories/$categoryId/playlists?$query',
        (json) => PlaylistSimple.fromJson(json),
        'playlists',
        (json) => PlaylistsFeatured.fromJson(json));
  }

  /// [playlistId] - the playlist ID
  ///
  /// [public] - Defaults to `true`. 
  Future<Null> followPlaylist(String playlistId, {bool public = true}) async {
    final url = 'v1/playlists/$playlistId/followers';
    final body = jsonEncode({'public': public});
    await _api._put(url, body);
  }

  /// [playlistId] - the playlist ID
  Future<Null> unfollowPlaylist(String playlistId) async {
    final url = 'v1/playlists/$playlistId/followers';
    await _api._delete(url);
  }
}