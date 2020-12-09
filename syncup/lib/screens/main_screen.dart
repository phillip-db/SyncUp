import 'package:flutter/material.dart';
import 'music_room.dart';

class MainScreen extends StatefulWidget {
  static String route = "main";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  /// Animation of rotating colors for background
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
    RoundedRectangleBorder _rectangleBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_buttonDimension * 0.15),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                      CreateRoomButton(
                        buttonDimension: _buttonDimension,
                        rectangleBorder: _rectangleBorder,
                      ),
                      JoinRoomButton(
                        buttonDimension: _buttonDimension,
                        rectangleBorder: _rectangleBorder,
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

/// Button to join a room
class JoinRoomButton extends StatefulWidget {
  final double _buttonDimension;
  final RoundedRectangleBorder _rectangleBorder;

  const JoinRoomButton({
    Key key,
    @required double buttonDimension,
    @required RoundedRectangleBorder rectangleBorder,
  })  : _buttonDimension = buttonDimension,
        _rectangleBorder = rectangleBorder,
        super(key: key);

  @override
  _JoinRoomButtonState createState() => _JoinRoomButtonState();
}

class _JoinRoomButtonState extends State<JoinRoomButton> {
  TextEditingController _c;
  String _code = 'CS196';

  @override
  void initState() {
    _c = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget._buttonDimension,
      height: widget._buttonDimension,
      child: RaisedButton(
        shape: widget._rectangleBorder,
        onPressed: () {
          _promptRoomCode(context);
        },
        child: ButtonText(buttonText: 'Join Room'),
      ),
    );
  }

  /// Brings up prompt for room code
  Future _promptRoomCode(BuildContext context) {
    return showDialog(
      context: context,
      child: Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLength: 5,
                  decoration: InputDecoration(hintText: 'Room Code'),
                  controller: _c,
                ),
              ),
              FlatButton(
                child: Text('Join'),
                onPressed: () {
                  String input = _c.text;
                  print('Inputted Code: $input');
                  if (input == _code) {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, MusicRoom.route);
                  } else {
                    Navigator.pop(context);
                    _alertInvalidCode(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Alerts user upon inputting an invalid code
  Future _alertInvalidCode(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Room Code'),
          content: Text('Please input a valid code.'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}

/// Button to create a new room
class CreateRoomButton extends StatelessWidget {
  const CreateRoomButton({
    Key key,
    @required double buttonDimension,
    @required RoundedRectangleBorder rectangleBorder,
  })  : _buttonDimension = buttonDimension,
        _rectangleBorder = rectangleBorder,
        super(key: key);

  final double _buttonDimension;
  final RoundedRectangleBorder _rectangleBorder;

  @override
  Widget build(BuildContext context) {
    var raisedButton = RaisedButton(
      shape: _rectangleBorder,
      onPressed: () {
        Navigator.pushNamed(
          context,
          MusicRoom.route,
        );
      },
      child: ButtonText(buttonText: 'Create Room'),
    );
    return Container(
      width: _buttonDimension,
      height: _buttonDimension,
      child: raisedButton,
    );
  }
}

/// Centered text for main screen buttons
class ButtonText extends StatelessWidget {
  const ButtonText({
    Key key,
    @required this.buttonText,
  }) : super(key: key);

  final buttonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        buttonText,
        textAlign: TextAlign.center,
        textScaleFactor: 3,
      ),
    );
  }
}
