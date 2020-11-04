import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'music_room.dart';

class SearchSong {
  final String title;
  final String artist;
  final String cover;
  final String dj;

  SearchSong(this.title, this.artist, this.cover, this.dj);
}

class SongScreen extends StatelessWidget {
  static String route = "addSongScreen";

  Future<List<SearchSong>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    return List.generate(10, (int index) {
      return SearchSong(
        "$search ${index + 1}",
        "CS196",
        'assets/images/song_placeholder.png',
        "Group 15",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Song'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<SearchSong>(
            textStyle: TextStyle(color: Colors.white),
            icon: Icon(Icons.search, color: Colors.white),
            loader: Center(
              child: Text('Syncing your song...'),
            ),
            onSearch: search,
            onItemFound: (SearchSong post, int index) {
              return ListTile(
                leading: Image(
                  image: AssetImage(post.cover),
                  width: 50,
                ),
                title: Text(post.title),
                subtitle: Text(post.artist),
                onTap: () {
                  Song(
                    post.title,
                    post.artist,
                    post.cover,
                    post.dj,
                  ).addSong();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
