import 'package:flutter/material.dart';
import 'package:syncup/routes.dart';
import 'package:syncup/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SyncUp',
      theme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.grey[900],
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue[800],
          textTheme: ButtonTextTheme.normal,
        ),
        textTheme: TextTheme(
          caption: TextStyle(
            fontSize: 12,
          ),
          headline4: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      initialRoute: LoginScreen.route,
      routes: getRoutes(),
    );
  }
}

BoxDecoration opacityBackground() {
  return BoxDecoration(
    color: Colors.white,
  );
}
