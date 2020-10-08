import 'package:flutter/material.dart';
import '../main.dart';
import 'login_screen.dart';
import 'music_room.dart';

class MainScreen extends StatefulWidget {
  static String route = "main";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animatable<Color> background = TweenSequence<Color>(
    [
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.red,
          end: Colors.green,
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.green,
          end: Colors.blue,
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.blue,
          end: Colors.pink,
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.pink,
          end: Colors.red,
        ),
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Main Screen"),
      ),
      body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              color: background
                  .evaluate(AlwaysStoppedAnimation(_controller.value)),
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          LoginScreen.route,
                        );
                      },
                      child: Text('Go back!'),
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          MusicRoom.route,
                        );
                      },
                      child: Text('Enter Room'),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
