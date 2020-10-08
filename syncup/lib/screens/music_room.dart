import 'package:flutter/material.dart';
import '../main.dart';
import 'main_screen.dart';

class MusicRoom extends StatefulWidget {
  static String route = 'music_room';

  @override
  _MusicRoomState createState() => _MusicRoomState();
}

class _MusicRoomState extends State<MusicRoom> {
  String _roomOwner = 'Group 15(Best Group)';
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: buildAppBar(),
      body: Container(
        decoration: opacityBackground(),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [buildSongImage(context)],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(textTheme),
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

  Container buildSongImage(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .1),
        child: Image(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/song_placeholder.png'),
        ),
      ),
    );
  }
}
