import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:spotify/spotify.dart' as musicroomspotify;
import '../marquee.dart';
import '../members.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';

/// Constant value specifying a max width as a percentage of screen width
final double maxWidthPct = 0.75;

/// List of songs to be played
List<Song> songs = [];

/// (Debug) Counter to prevent songs from being added on quick reloads
int count = 0;

/// Ensures all the components of the music plater are loaded and set
bool _loading = false;

/// Checks if the spotify player is able to connect to the music that was requested
bool _connected = false;

/// Logs any errors with the Spotify SDK plugin
final Logger _logger = Logger();

/// Spotify SDK plugin
musicroomspotify.SpotifyApi spotify;

/// Current Artist, Title and ImageUri (Currently Having Problems updating ImageUri)
String currentArtist = "Default Artist";
String currentTitle = "Default Title";
String currentAlbum = "Default Album";
String currentImageUri =
    "spotify:image:ab67616d0000b2736b4f6358fbf795b568e7952d"; //default value
String spotifyUri = "spotify:track:28UMEtwyUUy5u0UWOVHwiI"; //default value

/// How far the song is from completing
double playbackPercent = 0;
int currentSongTime = 0;
int songLength = 0;

class MusicRoom extends StatefulWidget {
  static String route = 'music';

  @override
  _MusicRoomState createState() => _MusicRoomState();
}

class _MusicRoomState extends State<MusicRoom> {
  String _roomOwner = 'Group 15(Best Group)';
  String songSource = 'Group 15';
  double songDuration = 220;
  Song nowPlaying = Song(currentTitle, currentArtist,
      'assets/images/song_placeholder.png', 'Group 15');

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.black45;

    if (count == 0) {
      setSongs();
      count++;
    }

    return MaterialApp(
      home: StreamBuilder<ConnectionStatus>(
          stream: SpotifySdk.subscribeConnectionStatus(),
          builder: (context, snapshot) {
            _connected = false;
            if (snapshot.data != null) {
              _connected = snapshot.data.connected;
            }
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: buildAppBar(),
              endDrawer: MemberListDrawer(),
              body: Stack(children: <Widget>[
                _connected
                    ? playerStateWidget()
                    : const Center(
                        child: Text('Not connected'),
                      ),
                mainBody(context, currentTitle, currentArtist, bgColor),
              ]),
            );
          }),
    );
  }

  /// Container including everything besides the app bar and song list
  Container mainContainer(String songTitle, String songArtist, Color bgColor) {
    return Container(
        color: bgColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SongSource(songSource: songSource),
            SongImage(),
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  VoteSkipButton(),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: buildSongInfo(songTitle, songArtist),
                  ),
                  SongOptionsButton(
                    songSource: songSource,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: PlaybackControls(),
              ),
            ),
          ],
        ));
  }

  /// Main body of the music room
  SlidingUpPanel mainBody(BuildContext context, String songTitle,
      String songArtist, Color bgColor) {
    return SlidingUpPanel(
        color: Colors.grey[850],
        minHeight: 60,
        maxHeight: MediaQuery.of(context).size.height * 0.85,
        backdropOpacity: 1.0,
        parallaxEnabled: true,
        parallaxOffset: .5,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
        panelBuilder: (scrollController) => buildSlidingPanel(scrollController),
        body: mainContainer(songTitle, songArtist, bgColor));
  }

  /// Builds sliding panel containing the song list
  Widget buildSlidingPanel(ScrollController sc) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(controller: sc, children: <Widget>[
        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
            ),
          ],
        ),
        SizedBox(
          height: 18.0,
        ),
        currentlyPlaying(new Song(currentTitle, currentArtist,
            'assets/images/song_placeholder.png', 'Group 15')),
        SizedBox(
          height: 18.0,
        ),
        Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              'Up Next',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            )),
        SizedBox(
          height: 5.0,
        ),
        Container(
            child: Column(
                children: songs
                    .map((i) => new SlidableWidget(
                        child: UpcomingSongList(song: i),
                        key: Key('i.name ' + i.artist),
                        song: i))
                    .toList())),
      ]),
    );
  }

  /// Builds a song's title and artist below the image
  Column buildSongInfo(String songTitle, String songArtist) {
    _connected
        ? playerStateWidget()
        : const Center(
            child: Text('Not connected'),
          );
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MarqueeWidget(
          child: Text(
            currentTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        MarqueeWidget(
            child: Text(
          currentArtist,
          style: TextStyle(
            color: Colors.grey,
          ),
        )),
      ],
    );
  }

  /// Builds app bar containing room owner and member list.
  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(_roomOwner + '\'s Room'),
      backgroundColor: Colors.grey[850],
      shadowColor: Colors.black54,
      actions: [
        Builder(
          builder: (context) => IconButton(
              icon: Icon(
                Icons.people,
                size: 30,
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer()),
        ),
      ],
    );
  }
}

/// Sets the text above the song image to the source/DJ of the current song.
class SongSource extends StatefulWidget {
  SongSource({
    Key key,
    @required this.songSource,
  }) : super(key: key);

  final String songSource;

  @override
  _SongSourceState createState() => _SongSourceState();
}

class _SongSourceState extends State<SongSource> {
  @override
  Widget build(BuildContext context) {
    double _maxWidth = MediaQuery.of(context).size.width * maxWidthPct;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: _maxWidth,
        height: 20,
        child: Center(
          child: MarqueeWidget(
            direction: Axis.horizontal,
            child: Text(
              'DJ: ${widget.songSource}',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

/// Builds the widget containing the image for the currently playing song.
class SongImage extends StatefulWidget {
  SongImage({Key key}) : super(key: key);

  @override
  _SongImageState createState() => _SongImageState();
}

class _SongImageState extends State<SongImage> {
  @override
  Widget build(BuildContext context) {
    double _horizontalPadding =
        MediaQuery.of(context).size.width * ((1 - maxWidthPct) / 3.5);

    return Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(
            left: _horizontalPadding,
            right: _horizontalPadding,
            top: 12,
          ),
          child: spotifyImageWidget(),
        ));
  }
}

/// Drawer that opens on the right side of the screen displaying room members
class MemberListDrawer extends StatefulWidget {
  MemberListDrawer({
    Key key,
  }) : super(key: key);

  @override
  _MemberListDrawerState createState() => _MemberListDrawerState();
}

class _MemberListDrawerState extends State<MemberListDrawer> {
  @override
  Widget build(BuildContext context) {
    List<ListTile> roomMembers = Members.members.map(
      (String member) {
        return ListTile(
          visualDensity: VisualDensity(vertical: 2),
          title: Container(
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  size: 30,
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      member,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).toList();

    return Container(
      child: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.grey[900],
              height: MediaQuery.of(context).size.height * 0.15,
              child: DrawerHeader(
                margin: EdgeInsets.zero,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.ltr,
                  children: [
                    Text(
                      'Room Members',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 0),
                itemCount: roomMembers.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(child: roomMembers[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Button for each song displaying various options
class SongOptionsButton extends StatefulWidget {
  SongOptionsButton({
    Key key,
    @required this.songSource,
  }) : super(key: key);

  final songSource;

  @override
  _SongOptionsButtonState createState() => _SongOptionsButtonState();
}

class _SongOptionsButtonState extends State<SongOptionsButton> {
  Future<void> _launched;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert, color: Colors.white),
      tooltip: 'Song Options',
      onSelected: (value) {
        if (value == 3) {
          _launchInBrowser();
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 1,
          child: Text("DJ: ${widget.songSource}"),
        ),
        PopupMenuItem(
          value: 2,
          child: Divider(
            height: 1,
            thickness: 2,
          ),
        ),

        /// Open Spotify and display the linked song
        PopupMenuItem(
          value: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Find on Spotify'),
              Icon(Icons.speaker),
            ],
          ),
        ),
      ],
    );
  }
}

Future<void> _launchInBrowser() async {
  if (await canLaunch(spotifyUri)) {
    await launch(
      spotifyUri,
      forceWebView: false,
      headers: <String, String>{'header_key': 'header_value'},
    );
  } else {
    throw 'Could not launch $spotifyUri';
  }
}

/// Playback controls for current song, includes song progress bar
class PlaybackControls extends StatefulWidget {
  _PlaybackControlsState createState() => _PlaybackControlsState();
}

class _PlaybackControlsState extends State<PlaybackControls> {
  Duration _songDuration = new Duration(minutes: 3, seconds: 30);
  Duration _songProgress = new Duration(minutes: 2, seconds: 15);

  format(Duration d) => d.toString().substring(2, 7);
  minToSec(Duration d) => 60 * int.parse(d.toString().substring(2, 4));
  seconds(Duration d) => minToSec(d) + int.parse(d.toString().substring(5, 7));

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      heightFactor: 1.0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: LinearProgressIndicator(
              value: seconds(_songProgress) / seconds(_songDuration),
              backgroundColor: Colors.grey[900],
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    format(_songProgress),
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Text(
                    format(_songDuration - _songProgress),
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: PlaybackButton(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Button to toggle vote skip indication
class VoteSkipButton extends StatefulWidget {
  @override
  _VoteSkipButtonState createState() => _VoteSkipButtonState();
}

class _VoteSkipButtonState extends State<VoteSkipButton> {
  bool _isVoteSkipped = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * .01),
      child: IconButton(
        icon: (_isVoteSkipped
            ? Icon(Icons.skip_next, color: Colors.red)
            : Icon(Icons.skip_next, color: Colors.white)),
        tooltip: 'Vote to skip current song',
        onPressed: _toggleVoteSkip,
        iconSize: 30,
      ),
    );
  }

  void _toggleVoteSkip() {
    setState(() => _isVoteSkipped = !_isVoteSkipped);
    skipNext();
    playerStateWidget();
    // ignore: invalid_use_of_protected_member
    (context as Element).reassemble();
  }

  Future<void> skipNext() async {
    if (_isVoteSkipped) {
      try {
        await SpotifySdk.skipNext();
      } on PlatformException catch (e) {
        setStatus(e.code, message: e.message);
      } on MissingPluginException {
        setStatus('not implemented');
      }
    }
  }
}

/// Pauses or resumes playback of songs for this user only
class PlaybackButton extends StatefulWidget {
  @override
  _PlaybackButtonState createState() => _PlaybackButtonState();
}

class _PlaybackButtonState extends State<PlaybackButton> {
  bool _isPaused = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.white,
      padding: EdgeInsets.all(0),
      icon: (_isPaused ? Icon(Icons.pause) : Icon(Icons.play_arrow)),
      iconSize: 40,
      onPressed: _togglePlayback,
    );
  }

  void _togglePlayback() {
    setState(() => _isPaused = !_isPaused);
    pauseOrPlay();
    playerStateWidget();
    // ignore: invalid_use_of_protected_member
    (context as Element).reassemble();
  }

  Future<void> pauseOrPlay() async {
    if (_isPaused) {
      try {
        await SpotifySdk.resume();
      } on PlatformException catch (e) {
        setStatus(e.code, message: e.message);
      } on MissingPluginException {
        setStatus('not implemented');
      }
    } else {
      try {
        await SpotifySdk.pause();
      } on PlatformException catch (e) {
        setStatus(e.code, message: e.message);
      } on MissingPluginException {
        setStatus('not implemented');
      }
    }
  }
}

/// Displays song title and artist for currently playing song
Widget currentlyPlaying(Song song) {
  return Container(
    child: Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Image.asset(
                  song.imagePath,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: MarqueeWidget(
                        child: Text(
                          song.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 3),
                      child: MarqueeWidget(
                        child: Text(
                          song.artist,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// Stores information about a given song (name, artist, etc.).
class Song {
  String name;
  String artist;
  String imagePath;
  String dj;
  bool upvoted = false;
  bool downvoted = false;
  bool voted = false;

  Song(String name, String artist, String imagePath, String dj) {
    this.name = name;
    this.artist = artist;
    this.imagePath = imagePath;
    this.dj = dj;
  }

  void upvote() {
    upvoted = !upvoted;
    downvoted = false;
    if (upvoted == false) {
      voted = false;
    } else {
      voted = true;
    }
  }

  void downvote() {
    downvoted = !downvoted;
    upvoted = false;
    if (downvoted == false) {
      voted = false;
    } else {
      voted = true;
    }
  }
}

/// Initialize list of songs for testing
void setSongs() {
  // For Testing:
  for (int i = 1; i <= 20; i++) {
    Song newSong = new Song(
        'This is Example Song ' + i.toString(),
        'artist ' + i.toString(),
        'assets/images/song_placeholder.png',
        'Group 15');
    songs.add(newSong);
  }
  Song longSong = new Song(
      'Example long long long long long long title',
      'Example long long long long long long long long long long artist',
      'assets/images/song_placeholder.png',
      'long long long long long long long DJ');
  songs.add(longSong);
}

/// Displays scrolling list of upcoming songs
class UpcomingSongList extends StatefulWidget {
  final Song song;

  const UpcomingSongList({@required this.song, key}) : super(key: key);

  @override
  _UpcomingSongListState createState() => _UpcomingSongListState(song: song);
}

class _UpcomingSongListState extends State<UpcomingSongList> {
  final Song song;

  _UpcomingSongListState({
    Key key,
    @required this.song,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 7),
        height: 70.0,
        color: Colors.grey[850],
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 3,
            vertical: 3,
          ),
          leading: Image.asset(
            song.imagePath,
            width: 40,
            fit: BoxFit.cover,
          ),
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: MarqueeWidget(
                        child: Text(
                          song.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 3),
                      child: MarqueeWidget(
                        child: Text(
                          song.artist,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(0.2),
                    width: 40.0,
                    child: Icon(song.upvoted ? Icons.thumb_up : null,
                        color: song.upvoted ? Colors.green : Colors.white),
                  ),
                  Container(
                    padding: EdgeInsets.all(0.2),
                    width: 40.0,
                    child: Icon(song.downvoted ? Icons.thumb_down : null,
                        color: song.downvoted ? Colors.red : Colors.white),
                  ),
                  Container(
                    padding: EdgeInsets.all(0.2),
                    width: 40.0,
                    child: Icon(song.voted ? null : Icons.thumbs_up_down,
                        color: Colors.white),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(right: 20.0),
                width: 50.0,
                child: SongOptionsButton(
                  songSource: song.dj,
                ),
              )
            ],
          ),
        ));
  }
}

/// Toggle upvote status of song
void _onUpvoteIconPressed(Song song) {
  if (song.upvoted) {
    song.upvoted = !song.upvoted;
  } else {
    song.upvote();
  }
}

/// Toggle downvote status of song
void _onDownvoteIconPressed(Song song) {
  if (song.downvoted) {
    song.downvoted = !song.downvoted;
  } else {
    song.downvote();
  }
}

/// Allows the  ListTile to slide left or right and upvote/downvote a song
class SlidableWidget<T> extends StatelessWidget {
  final Widget child;
  final Key key;
  final Song song;

  const SlidableWidget({
    @required this.child,
    @required this.key,
    @required this.song,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
        actionPane: SlidableDrawerActionPane(),
        child: child,
        actionExtentRatio: 0.0,
        key: key,
        dismissal: SlidableDismissal(
          dismissThresholds: <SlideActionType, double>{
            SlideActionType.primary: 0.1,
            SlideActionType.secondary: 0.1,
          },
          child: SlidableDrawerDismissal(),
          onWillDismiss: (SlideActionType actionType) {
            if (actionType == SlideActionType.primary) {
              song.upvote();
            }
            if (actionType == SlideActionType.secondary) {
              song.downvote();
            }
            return false;
          },
        ),

        // Sliding left for upvote:
        actions: <Widget>[
          Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.green[100], Colors.green[300]]),
              ),
              child: IconSlideAction(
                caption: 'Upvote',
                color: Colors.transparent,
                icon: Icons.thumb_up,
              )),
        ],

        // Sliding right for downvote:
        secondaryActions: <Widget>[
          Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.red[100], Colors.red[300]]),
              ),
              child: IconSlideAction(
                caption: 'Downvote',
                color: Colors.transparent,
                icon: Icons.thumb_down,
              )),
        ]);
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
      builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
        if (snapshot.data != null && snapshot.data.track != null) {
          var playerState = snapshot.data;
          currentImageUri = playerState.track.imageUri.raw;
          spotifyUri = playerState.track.uri;
          currentArtist = playerState.track.artist.name;
          currentTitle = playerState.track.name;
          currentAlbum = playerState.track.album.name;
          currentSongTime = playerState.playbackPosition;
          songLength = playerState.track.duration;
          print("Song Time is $currentSongTime");
          print("Song Length is $songLength");
          playbackPercent =
              playerState.playbackPosition / playerState.track.duration;
          print("Playback Percentage is $playbackPercent");
          return Container(width: 0.0, height: 0.0);
        } else {
          return Container(width: 0.0, height: 0.0);
        }
      });
}

Widget spotifyImageWidget() {
  return FutureBuilder(
      future: SpotifySdk.getImage(
          imageUri: ImageUri(currentImageUri), dimension: ImageDimension.large),
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
