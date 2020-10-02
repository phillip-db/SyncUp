import 'package:flutter/material.dart';
import 'package:syncup/routes.dart';
import 'package:syncup/screens/login_screen.dart';
import 'package:syncup/screens/main_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SyncUp',
      theme: ThemeData(
        primaryColor: Colors.grey[900],
        accentColor: Colors.black87,
      ),
      initialRoute: LoginScreen.route,
      routes: getRoutes(),
    );
  }
}

BoxDecoration gradientBackground() {
  return BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Colors.grey[600], Colors.grey[850]]),
  );
}
