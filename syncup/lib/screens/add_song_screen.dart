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
  final List<Song> songs;
  SongScreen(this.songs);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Add Song'),
        ),
        body: searchWidget());
  }
}

Builder searchWidget() {
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

  return Builder(builder: (BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SearchBar<SearchSong>(
          minimumChars: 1,
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
                Scaffold.of(context).hideCurrentSnackBar();
                Song newSong =
                    Song(post.title, post.artist, post.cover, post.dj);
                if (!songAlreadyAdded(newSong)) {
                  newSong.addSong();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.greenAccent[400],
                    content: Text(newSong.name + " Added to Queue"),
                    duration: Duration(seconds: 3),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        Scaffold.of(context).hideCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red[200],
                          content: Text(newSong.name + " Removed")
                        ));
                        newSong.removeSong();
                      }
                    )
                  ));
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green[100],
                      content: Text(newSong.name + " is Already Added"),
                      duration: Duration(seconds: 1)));
                }
              },
            );
          },
        ),
      ),
    );
  });
}

bool songAlreadyAdded(Song newSong) {
  for (Song song in songs) {
    if (song.name == newSong.name && song.artist == newSong.artist) {
      return true;
    }
  }
  return false;
}
