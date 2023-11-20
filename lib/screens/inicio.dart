// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:intsplay/screens/kp4.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../views/hogar.dart';
import '../views/player.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({Key? key}) : super(key: key);

  @override
  _InicioScreenState createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  int _selectedIndex = 0;
  late AudioPlayer audioPlayer;
  bool blinking = false;
  Timer? blinkTimer;

  List<Widget> vistas = [];

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    vistas = [const PlayerView(), const SeleccionadoView()];

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
                MaterialPageRoute(builder: (context) => const KP4Screen()),
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
      backgroundColor: Theme.of(context).colorScheme.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: vistas,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Theme.of(context).colorScheme.tertiary,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: _selectedIndex == 0
                  ? Icon(
                      Ionicons.radio,
                      color: Theme.of(context).primaryColor,
                    )
                  : Icon(
                      Ionicons.radio_outline,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              onPressed: () {
                _onItemTapped(0);
              },
            ),
            IconButton(
              icon: _selectedIndex == 1
                  ? Icon(
                      Ionicons.bookmark,
                      color: Theme.of(context).primaryColor,
                    )
                  : Icon(
                      Ionicons.bookmark_outline,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              onPressed: () {
                _onItemTapped(1);
              },
            ),
          ],
        ),
      ),
    );
  }
}
