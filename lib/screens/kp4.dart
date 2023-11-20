import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intsplay/screens/inicio.dart';

import '../generated/l10n.dart';

class KP4Screen extends StatefulWidget {
  const KP4Screen({super.key});

  @override
  State<KP4Screen> createState() => _KP4ScreenState();
}

class _KP4ScreenState extends State<KP4Screen> {
  bool blinking = false;
  Timer? blinkTimer;

  List<Widget> vistas = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Center(
          child: GestureDetector(
            onLongPress: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const InicioScreen()),
              );
            },
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const InicioScreen()),
              );
            },
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
        ),
        elevation: 0,
      ),
      body: ListView(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(bottom: 30, top: 50, left: 14, right: 14),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                S.current.titulokp4,
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 18, right: 18),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                S.current.contenidokp4,
                style: TextStyle(
                  fontSize: 22,
                  height: 1.4,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
