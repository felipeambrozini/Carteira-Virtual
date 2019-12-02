import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_teste/views/login.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatefulWidget {
 Splash({Key key, this.title}) : super(key: key);
  final String title;
  static const String routeName = '/home';

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return _introScreen();
  }
}

Widget _introScreen() {
  return Stack(
    children: <Widget>[
      SplashScreen(
        seconds: 3,
        gradientBackground: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xff2e8b57),
            Color(0xff2e8b57)
          ],
        ),
        navigateAfterSeconds: Login(),
        loaderColor: Colors.green,
      ),
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/icon/splashscreen.png"),
            fit: BoxFit.none,
          ),
        ),
      ),
    ],
  );
 
}