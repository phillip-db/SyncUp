import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/music_room.dart';

getRoutes() {
  return {
    MainScreen.route: (context) => MainScreen(),
    LoginScreen.route: (context) => LoginScreen(),
    MusicRoom.route: (context) => MusicRoom(),
  };
}
