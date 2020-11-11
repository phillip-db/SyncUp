import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/music_room.dart';
import 'screens/add_song_screen.dart';

getRoutes() {
  return {
    MainScreen.route: (context) => MainScreen(),
    LoginScreen.route: (context) => LoginScreen(),
    MusicRoom.route: (context) => MusicRoom(),
    SongScreen.route: (context) => SongScreen(songs),
  };
}
