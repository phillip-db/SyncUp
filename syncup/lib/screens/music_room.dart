import 'package:flutter/material.dart';
import '../marquee.dart';
import '../members.dart';
import 'add_song_screen.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

double maxWidthPct = 0.75;
List<Song> songs = [];
bool slidingPanelOpen = false;

class MusicRoom extends StatefulWidget {
  static String route = 'music';

  @override
  _MusicRoomState createState() => _MusicRoomState();
}

class _MusicRoomState extends State<MusicRoom> {
  String _roomOwner = 'Group 15(Best Group)';
  String songSource = 'Group 15';
  double songDuration = 220;

  @override
  Widget build(BuildContext context) {
    String songTitle = 'CS 196';
    String songArtist = 'Sami & Rohan (ft. Course Staff)';
    Color bgColor = Colors.black45;

    setSongs();

    Offset _pointerDownPosition;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: buildAppBar(),
        endDrawer: MemberListDrawer(),
        body: Listener(
          child: mainBody(context, songTitle, songArtist, bgColor),
          onPointerDown: (details) {
            if (slidingPanelOpen) {
              _pointerDownPosition = Offset.infinite;
            } else {
              _pointerDownPosition = details.position;
            }
          },
          onPointerUp: (details) {
            if (details.position.dy - _pointerDownPosition.dy > 100.0) {
              Navigator.pushNamed(context, SongScreen.route);
            }
          },
        )
    );
  }

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

  SlidingUpPanel mainBody(BuildContext context, String songTitle,
      String songArtist, Color bgColor) {
    return SlidingUpPanel(
        onPanelOpened: () {
          slidingPanelOpen = true;
        },
        onPanelClosed: () {
          slidingPanelOpen = false;
        },
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

  Widget buildSlidingPanel(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Stack(
          children: [
            ListView(
              controller: sc, 
              children: <Widget>[
                SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                currentlyPlaying(new Song(
                  'CS 196',
                  'Sami & Rohan (ft. Course Staff)',
                  'assets/images/song_placeholder.png',
                  'Group 15')),
                SizedBox(
                  height: 18.0,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Up Next',
                    style: TextStyle(
                      color: Colors.cyan,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  child: Column(
                    children: songs
                        .map((i) => new SlidableWidget(
                            child: UpcomingSongList(song: i),
                            key: Key('i.name ' + i.artist),
                            song: i)).toList()
                  )
                ),
              ]
            ),
            Positioned(
              right: 2,
              bottom: 60,
              width: 100,
              height: 100,
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  backgroundColor: Colors.deepOrange,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.deepOrange, Colors.orange[100]]
                      )
                    ),
                    child: Icon(Icons.add, color: Colors.grey[600]),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, SongScreen.route);
                  },
                ),
              ),
            ),
          ]
        )
    );
  }

  Column buildSongInfo(String songTitle, String songArtist) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MarqueeWidget(
          child: Text(
            songTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        MarqueeWidget(
            child: Text(
          songArtist,
          style: TextStyle(
            color: Colors.grey,
          ),
        )),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(_roomOwner + '\'s Room'),
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
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
      ),
    );
  }
}

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
        child: Image(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/song_placeholder.png'),
        ),
      ),
    );
  }
}

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

class SongOptionsButton extends StatefulWidget {
  SongOptionsButton({
    Key key,
    @required this.songSource,
  }) : super(key: key);

  final songSource;

  @override
  _SongOptionsButtonState createState() =>
      _SongOptionsButtonState(songSource: songSource);
}

class _SongOptionsButtonState extends State<SongOptionsButton> {
  _SongOptionsButtonState({
    Key key,
    @required this.songSource,
  });

  final songSource;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      tooltip: 'Song Options',
      onSelected: (value) {},
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 1,
          child: Text("DJ: $songSource"),
        ),
        PopupMenuItem(
          value: 2,
          child: Divider(
            height: 1,
            thickness: 2,
          ),
        ),
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
        PopupMenuItem(
          value: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Upvote'),
              Icon(Icons.keyboard_arrow_up),
            ],
          ),
        ),
        PopupMenuItem(
          value: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Downvote'),
              Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),
      ],
    );
  }
}

class PlaybackControls extends StatefulWidget {
  _PlaybackControlsState createState() => _PlaybackControlsState();
}

class _PlaybackControlsState extends State<PlaybackControls> {
  Duration _songDuration = Duration(minutes: 3, seconds: 40);
  Duration _songProgress = Duration(minutes: 2, seconds: 30);

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
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(format(_songProgress)),
                  Text(format(_songDuration - _songProgress)),
                ],
              ),
              PlaybackButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class VoteSkipButton extends StatefulWidget {
  @override
  _VoteSkipButtonState createState() => _VoteSkipButtonState();
}

class _VoteSkipButtonState extends State<VoteSkipButton> {
  bool _isVoteSkipped = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.01),
      child: IconButton(
        iconSize: 30,
        icon: (_isVoteSkipped
            ? Icon(Icons.skip_next, color: Colors.red)
            : Icon(Icons.skip_next, color: Colors.white)),
        tooltip: 'Vote to skip current song',
        onPressed: _toggleVoteSkip,
      ),
    );
  }

  void _toggleVoteSkip() {
    setState(() => _isVoteSkipped = !_isVoteSkipped);
  }
}

class PlaybackButton extends StatefulWidget {
  @override
  _PlaybackButtonState createState() => _PlaybackButtonState();
}

class _PlaybackButtonState extends State<PlaybackButton> {
  bool _isPaused = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: (_isPaused ? Icon(Icons.pause) : Icon(Icons.play_arrow)),
      iconSize: 40,
      onPressed: _togglePlayback,
    );
  }

  void _togglePlayback() {
    setState(() => _isPaused = !_isPaused);
  }
}

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

class Song {
  String name;
  String artist;
  String imagePath;
  String dj;
  bool upvoted = false;
  bool downvoted = false;

  Song(String name, String artist, String imagePath, String dj) {
    this.name = name;
    this.artist = artist;
    this.imagePath = imagePath;
    this.dj = dj;
  }

  void upvote() {
    upvoted = !upvoted;
    downvoted = false;
  }

  void downvote() {
    downvoted = !downvoted;
    upvoted = false;
  }

  void addSong() {
    songs.add(this);
  }

  void removeSong() {
    songs.remove(this);
  }
}

void setSongs() {
  // For Testing:
  int numSongs = 20;

  // Prevent the list from growing on quick refresh and reentering the room.
  if (songs.length < numSongs) {
    for (int i = 1; i <= numSongs; i++) {
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
}

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
              Container(
                padding: EdgeInsets.all(0.2),
                width: 40.0,
                child: IconButton(
                    icon: Icon(Icons.thumb_up,
                        color: song.upvoted ? Colors.green : Colors.white),
                    onPressed: () {
                      _onUpvoteIconPressed(song);
                      this.setState(() {});
                    }),
              ),
              Container(
                padding: EdgeInsets.all(0.2),
                width: 40.0,
                child: IconButton(
                    icon: Icon(Icons.thumb_down,
                        color: song.downvoted ? Colors.red : Colors.white),
                    onPressed: () {
                      _onDownvoteIconPressed(song);
                      this.setState(() {});
                    }),
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

void _onUpvoteIconPressed(Song song) {
  if (song.upvoted) {
    song.upvoted = false;
  } else {
    song.upvote();
  }
}

void _onDownvoteIconPressed(Song song) {
  if (song.downvoted) {
    song.downvoted = false;
  } else {
    song.downvote();
  }
}

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
