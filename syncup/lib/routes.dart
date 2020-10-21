import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/volume_test.dart';

getRoutes() {
  return {
    MainScreen.route: (context) => MainScreen(),
    LoginScreen.route: (context) => LoginScreen(),
    VolumeTest.route: (context) => VolumeTest(),
  };
}
