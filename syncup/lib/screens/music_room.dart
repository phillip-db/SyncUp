import 'package:flutter/material.dart';
import '../main.dart';
import '../marquee.dart';

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
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: buildAppBar(),
      body: Container(
          color: Colors.black45,
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
                    IconButton(
                      icon: Icon(Icons.more_vert),
                      tooltip: 'Song Options',
                      onPressed: () {},
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
          )),
      bottomNavigationBar: FractionallySizedBox(
        heightFactor: 0.07,
        child: buildBottomNavigationBar(context),
      ),
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
              songSource,
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
        IconButton(
          icon: Icon(Icons.people),
          tooltip: 'Room Members',
          onPressed: () {},
        ),
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

class PlaybackControls extends StatelessWidget {
  const PlaybackControls({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      heightFactor: 1.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: LinearProgressIndicator(
              value: 0.8,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0:00'),
              Text('3:00'),
            ],
          ),
          PlaybackButton(),
          SongListButton(),
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

class SongListButton extends StatefulWidget {
  @override
  _SongListButton createState() => _SongListButton();
}

class _SongListButton extends State<SongListButton> {
  bool _isSongListShowing = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Swipe'),
          Icon(
              _isSongListShowing ? Icons.arrow_drop_up : Icons.arrow_drop_down),
        ],
      ),
      onPressed: _toggleSongList,
    );
  }

  void _toggleSongList() {
    setState(() => _isSongListShowing = !_isSongListShowing);
  }
}
