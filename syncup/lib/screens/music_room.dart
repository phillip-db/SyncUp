import 'package:flutter/material.dart';
import '../marquee.dart';
import '../members.dart';

double maxWidthPct = 0.75;

class MusicRoom extends StatefulWidget {
  static String route = 'music';

  @override
  _MusicRoomState createState() => _MusicRoomState();
}

class _MusicRoomState extends State<MusicRoom> {
  String _roomOwner = 'Admin';
  String songSource = 'Group 15';
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    String songTitle = 'CS 196';
    String songArtist = 'Sami & Rohan';
    Color bgColor = Colors.black45;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: buildAppBar(),
      body: Container(
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
        PopupMenuItem(
            value: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Skip Song'),
                Icon(Icons.skip_next),
              ],
            )),
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
      tooltip: 'Member List',
      offset: Offset(1, MediaQuery.of(context).size.height),
      icon: Icon(Icons.people),
      onSelected: (value) {},
      itemBuilder: (BuildContext context) {
        return Members.members.map((String member) {
          return PopupMenuItem<String>(
            value: member,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onLongPress: () {
                showUserOptions(context, member);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
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
            ),
          );
        }).toList();
      },
    );
  }

  Future showUserOptions(BuildContext context, String member) {
    return showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
            0, MediaQuery.of(context).size.height * 0.117, 0, 0),
        items: <PopupMenuEntry>[
          PopupMenuItem(
            child: Container(
              child: Text(member),
              padding: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width * 0.15,
            ),
          ),
          PopupMenuDivider(
            height: 5,
          ),
          PopupMenuItem(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('DJ'),
                Icon(Icons.check),
              ],
            ),
          ),
          PopupMenuItem(
            child: Text('Kick'),
          ),
          PopupMenuItem(
            child: Text('Ban'),
          ),
        ]);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PlaybackButton(),
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(Icons.skip_next),
                iconSize: 40,
                tooltip: 'Skip Song',
                onPressed: () {},
              )
            ],
          ),
          SongListButton(),
        ],
      ),
    );
  }
}

class SkipButton {}

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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragUpdate: (DragUpdateDetails details) {
        _toggleSongList(details.delta.dy);
      },
      child: Container(
        width: double.infinity,
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Swipe'),
            Icon(_isSongListShowing
                ? Icons.arrow_drop_up
                : Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _toggleSongList(double dy) {
    if (dy < -2) {
      setState(() => _isSongListShowing = true);
    } else if (dy > 2) {
      setState(() => _isSongListShowing = false);
    }
  }
}
