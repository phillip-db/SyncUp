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
      body: mainBody(context, songTitle, songArtist, bgColor),
      bottomNavigationBar: FractionallySizedBox(
        heightFactor: 0.07,
        child: buildBottomNavigationBar(context),
      ),
    );
  }

  Container mainContainer(String songTitle, String songArtist, Color bgColor) {
    return Container(
        color: bgColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildSongSource(),
            _buildSongImage(context),
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

  SlidingUpPanel mainBody(BuildContext context, String songTitle, String songArtist, Color bgColor) {
    return SlidingUpPanel(
        minHeight: 50,
        maxHeight: MediaQuery.of(context).size.height,
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
                ]
              )
          )
      );

  Widget buildSlidingPanelBar() => PreferredSize(
      preferredSize: Size.fromHeight(30),
      child: AppBar(
        title: Icon(Icons.drag_handle),
        centerTitle: true,
        automaticallyImplyLeading: false,
        )
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

  Padding _buildSongSource() {
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
              'DJ: $songSource',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
      ),
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
      actions: [
        MemberList(),
      ],
    );
  }

  Container _buildSongImage(BuildContext context) {
    double _horizontalPadding =
        MediaQuery.of(context).size.width * ((1 - maxWidthPct) / 2);

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

class SongOptionsButton extends StatelessWidget {
  const SongOptionsButton({
    Key key,
  }) : super(key: key);

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
          child: Text('Option 2'),
        ),
        PopupMenuItem(
          value: 3,
          child: Text('Option 3'),
        ),
      ],
    );
  }
}

class MemberList extends StatelessWidget {
  const MemberList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: Offset(1, MediaQuery.of(context).size.height),
      icon: Icon(Icons.people),
      onSelected: (value) {},
      itemBuilder: (BuildContext context) {
        return Members.members.map((String member) {
          return PopupMenuItem<String>(
            value: member,
            child: Container(
              child: Row(
                children: [
                  Icon(Icons.person),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        member,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList();
      },
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
          currentlyPlaying('CS 196','Sami & Rohan'),
          Container(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              'Up Next',
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              )
            )
          ),
          addSongUpNext('Example title', 'Example artist'),
          addSongUpNext('Example title 2', 'Example artist 2'),
          addSongUpNext('Example title 3', 'Example artist 2'),
          addSongUpNext('Example title 4', 'Example artist 2'),
          addSongUpNext('Example title 5', 'Example artist 2'),
          addSongUpNext('Example title 5', 'Example artist 2'),
        ]
      )
    ]
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
                padding: const EdgeInsets.only(left: 5, top: 10),
                child: Image.asset(
                  'assets/images/song_placeholder.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        song,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        artist,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ]
                )
              )
            ],
          ) 
        )
      ],
    )

  );
}
Widget addSongUpNext(String song, String artist) {
  return Container(
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  song,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  artist,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
    ))
  ]));
}
