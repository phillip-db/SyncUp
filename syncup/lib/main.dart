import 'package:flutter/material.dart';
import 'package:syncup/routes.dart';
import 'package:syncup/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SyncUp',
      theme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.blue[500],
        textTheme: TextTheme(
            caption: TextStyle(
          fontSize: 12,
        )),
      ),
      initialRoute: LoginScreen.route,
      routes: getRoutes(),
    );
  }
}

BoxDecoration opacityBackground() {
  return BoxDecoration(
    color: Colors.black54,
  );
}
