import 'package:flutter/material.dart';
import '../marquee.dart';
import '../members.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

double maxWidthPct = 0.75;

class MusicRoom extends StatefulWidget {
  static String route = 'music';

  @override
  _MusicRoomState createState() => _MusicRoomState();
}

class _MusicRoomState extends State<MusicRoom> {
  String _roomOwner = 'Group 15(Best Group)';
  String songSource = 'Group 15';
  int _currentIndex = 1;
  double songDuration = 220;

  @override
  Widget build(BuildContext context) {
    String songTitle = 'CS 196';
    String songArtist = 'Sami & Rohan';
    Color bgColor = Colors.black45;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: buildAppBar(),
      endDrawer: MemberListDrawer(),
      body: mainBody(context, songTitle, songArtist, bgColor),
      // bottomNavigationBar: FractionallySizedBox(
      //   heightFactor: 0.07,
      //   child: buildBottomNavigationBar(context),
      // ),
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
                  SongOptionsButton(),
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
        minHeight: 30,
        maxHeight: MediaQuery.of(context).size.height * 0.9,
        panelBuilder: (scrollController) => buildSlidingPanel(
              scrollController: scrollController,
            ),
        body: mainContainer(songTitle, songArtist, bgColor));
  }

  Widget buildSlidingPanel({
    @required ScrollController scrollController,
  }) =>
      DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: buildSlidingPanelBar(),
          body: TabBarView(
            children: [
              ScrollUpPanel(scrollController: scrollController),
            ],
          ),
        ),
      );

  Widget buildSlidingPanelBar() => PreferredSize(
        preferredSize: Size.fromHeight(30),
        child: AppBar(
          title: Icon(Icons.drag_handle),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
      );

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

  BottomNavigationBar buildBottomNavigationBar(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BottomNavigationBar(
      selectedLabelStyle: textTheme.caption,
      unselectedLabelStyle: textTheme.caption,
      currentIndex: _currentIndex,
      onTap: (value) {
        setState(() => _currentIndex = value);
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 20),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.music_note, size: 20),
          title: Text('Music Room'),
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(_roomOwner + '\'s Room'),
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
    List<dynamic> items = [
      Container(
        color: Colors.grey[900],
        height: MediaQuery.of(context).size.height * 0.1,
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
    ];

    List roomMembers = Members.members.map(
      (String member) {
        return ListTile(
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

    items.addAll(roomMembers);

    return Container(
      child: Drawer(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(child: items[index]);
          },
        ),
      ),
    );
  }
}

class SongOptionsButton extends StatefulWidget {
  @override
  _SongOptionsButtonState createState() => _SongOptionsButtonState();
}

class _SongOptionsButtonState extends State<SongOptionsButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      tooltip: 'Song Options',
      onSelected: (value) {},
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Find on Spotify'),
              Icon(Icons.speaker),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Upvote'),
              Icon(Icons.keyboard_arrow_up),
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
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
    return IconButton(
      icon: (_isVoteSkipped
          ? Icon(Icons.thumb_down, color: Colors.red)
          : Icon(Icons.thumb_down, color: Colors.white)),
      tooltip: 'Vote to skip current song',
      onPressed: _toggleVoteSkip,
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
      padding: EdgeInsets.all(0),
      icon: (_isPaused ? Icon(Icons.pause) : Icon(Icons.play_arrow)),
      iconSize: 40,
      onPressed: _togglePlayback,
    );
  }

  void _togglePlayback() {
    setState(() => _isPaused = !_isPaused);
  }
}

class ScrollUpPanel extends StatelessWidget {
  const ScrollUpPanel({
    Key key,
    @required this.scrollController,
  }) : super(key: key);
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) => ListView(
        padding: EdgeInsets.all(30),
        controller: scrollController,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              currentlyPlaying('CS 196', 'Sami & Rohan'),
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Up Next',
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              addSongUpNext('Example title', 'Example artist'),
              addSongUpNext('Example title 2', 'Example artist 2'),
              addSongUpNext('Example title 3', 'Example artist 2'),
              addSongUpNext('Example title 4', 'Example artist 2'),
              addSongUpNext('Example title 5', 'Example artist 2'),
              addSongUpNext('Example title 5', 'Example artist 2'),
              addSongUpNext('Example title 6', 'Example artist 2'),
              addSongUpNext('Example title 7', 'Example artist 2'),
              addSongUpNext('Example title 8', 'Example artist 2'),
              addSongUpNext('Example title 9', 'Example artist 2'),
              addSongUpNext('Example title 10', 'Example artist 2'),
              addSongUpNext('Example long long long long long long title',
                  'Example long long long long long long long long long long artist'),
            ],
          ),
        ],
      );
}

Widget currentlyPlaying(String song, String artist) {
  return Container(
    child: Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: Image.asset(
                  'assets/images/song_placeholder.png',
                  width: 50,
                  height: 50,
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
                          song,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 3),
                      child: MarqueeWidget(
                        child: Text(
                          artist,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
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
        SongOptionsButton(),
      ],
    ),
  );
}

Widget addSongUpNext(String song, String artist) {
  return Container(
    padding: EdgeInsets.only(top: 15),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.only(right: 10),
          child: Image.asset(
            'assets/images/song_placeholder.png',
            width: 40,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: MarqueeWidget(
                  child: Text(
                    song,
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
                    artist,
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
        SongOptionsButton(),
      ],
    ),
  );
}
