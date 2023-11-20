import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intsplay/views/local-pages.dart';

import '../screens/inicio.dart';

class LocalView extends StatefulWidget {
  const LocalView({Key? key}) : super(key: key);

  @override
  _LocalViewState createState() => _LocalViewState();
}

class _LocalViewState extends State<LocalView> {
  bool blinking = false;
  Timer? blinkTimer;

  @override
  void initState() {
    super.initState();

    blinkTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      setState(() {
        blinking = !blinking;
      });
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          blinking = !blinking;
        });
      });
    });
  }

  @override
  void dispose() {
    blinkTimer?.cancel();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const InicioScreen()),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Center(
            child: Image.asset(
              blinking
                  ? (Theme.of(context).brightness == Brightness.dark
                      ? "assets/images/ints-oscuro-parpadeo.png"
                      : "assets/images/ints-blanco-parpadeo.png")
                  : (Theme.of(context).brightness == Brightness.dark
                      ? "assets/images/ints-oscuro.png"
                      : "assets/images/ints-blanco.png"),
              height: 24,
            ),
          ),
          elevation: 0,
        ),
        body: const LocalPageView(),
      ),
    );
  }
}
