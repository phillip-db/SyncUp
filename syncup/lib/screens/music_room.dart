import 'package:flutter/material.dart';
import '../main.dart';
import '../marquee.dart';

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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: buildAppBar(),
      body: Container(
        decoration: opacityBackground(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildSongSource(),
            _buildSongImage(context),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(textTheme),
    );
  }

  Padding _buildSongSource() {
    double _maxWidth = MediaQuery.of(context).size.width * .8;

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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar(TextTheme textTheme) {
    return BottomNavigationBar(
      selectedLabelStyle: textTheme.caption,
      unselectedLabelStyle: textTheme.caption,
      currentIndex: _currentIndex,
      onTap: (value) {
        setState(() => _currentIndex = value);
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.music_note),
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
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .1,
          vertical: 12,
        ),
        child: Image(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/song_placeholder.png'),
        ),
      ),
    );
  }
}
