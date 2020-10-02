import 'screens/login_screen.dart';
import 'screens/main_screen.dart';

getRoutes() {
  return {
    MainScreen.route: (context) => MainScreen(),
    LoginScreen.route: (context) => LoginScreen(),
  };
}
