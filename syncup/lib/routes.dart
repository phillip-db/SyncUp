import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/spotify_api_test.dart';
import 'screens/home_screen.dart';
import 'screens/music_screen_test.dart';
import 'screens/music_room.dart';

getRoutes() {
  return {
    MainScreen.route: (context) => MainScreen(),
    LoginScreen.route: (context) => LoginScreen(),
    SpotifyApiTest.route: (context) => SpotifyApiTest(),
    HomeScreen.route: (context) => HomeScreen(),
    MusicScreenTest.route: (context) => MusicScreenTest(),
    MusicRoom.route: (context) => MusicRoom(),
  };
}
