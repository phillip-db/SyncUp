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
    double _buttonDimension = MediaQuery.of(context).size.width * 0.5;

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
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.05),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      NavigationButton(
                        buttonDimension: _buttonDimension,
                        navRoute: LoginScreen.route,
                        buttonText: 'Go Back',
                      ),
                      NavigationButton(
                        buttonDimension: _buttonDimension,
                        navRoute: MusicRoom.route,
                        buttonText: 'Join Room',
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class NavigationButton extends StatelessWidget {
  const NavigationButton({
    Key key,
    @required double buttonDimension,
    @required this.navRoute,
    @required this.buttonText,
  })  : _buttonDimension = buttonDimension,
        super(key: key);

  final double _buttonDimension;
  final navRoute;
  final buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _buttonDimension,
      height: _buttonDimension,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_buttonDimension * 0.15),
        ),
        onPressed: () {
          Navigator.pushNamed(
            context,
            navRoute,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            textScaleFactor: 3,
          ),
        ),
      ),
    );
  }
}
