import 'dart:async';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      Duration(seconds: 2),
      () => Navigator.of(context).pushReplacement(
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: Home(),
          duration: Duration(seconds: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1d59c3),
      body: Center(
        child: Hero(
          tag: 'logo',
          child: Image.asset(
            'assets/images/logo.jpeg',
          ),
        ),
      ),
    );
  }
}
