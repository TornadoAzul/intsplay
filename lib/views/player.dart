// ignore_for_file: library_private_types_in_public_api
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';
import '../generated/l10n.dart';
import '../screens/find.dart';

class PlayerView extends StatefulWidget {
  const PlayerView({super.key});

  @override
  _PlayerViewState createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> emisoras = [];
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int currentEmisoraIndex = 0;
  bool isPausedByUser = false;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    loadEmisoras();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  void loadEmisoras() async {
    final prefs = await SharedPreferences.getInstance();
    final emisorasData = prefs.getStringList('savedRadios');
    if (emisorasData != null) {
      setState(() {
        emisoras = emisorasData.map((emisoraData) {
          final Map<String, dynamic> data = jsonDecode(emisoraData);
          return {
            'name': data['name'] as String,
            'url': data['url'] as String,
          };
        }).toList();
      });
    }

    if (emisoras.isNotEmpty) {
      final firstEmisoraUrl = emisoras[0]['url'] as String;
      playEmisora(firstEmisoraUrl);
    }
  }

  Future<void> playEmisora(String url) async {
    try {
      await audioPlayer.setUrl(url);
      audioPlayer.play();
      audioPlayer.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          // La reproducción ha terminado
          setState(() {
            isPlaying = false;
          });
        }
      });
      setState(() {
        isPlaying = true;
        isPausedByUser = false;
      });
    } catch (e) {
      // Error al reproducir la emisora
    }
  }

  Future<void> togglePlayback() async {
    if (isPlaying && !isPausedByUser) {
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
        isPausedByUser = true;
      });
    } else {
      await audioPlayer.play();
      setState(() {
        isPlaying = true;
        isPausedByUser = false;
      });
    }
  }

  IconData getPlaybackIcon() {
    return isPlaying ? Ionicons.pause_outline : Ionicons.play_outline;
  }

  @override
  Widget build(BuildContext context) {
    if (emisoras.isEmpty) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? "assets/images/introduccion_oscuro.png"
                    : "assets/images/introduccion_claro.png",
                height: 330,
              ),
              Container(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
                child: Text(
                  S.current.saludo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 26, height: 1.1, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 10, bottom: 10),
                child: Text(
                  S.current.descripcionaddemisora,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, height: 1.1),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double>(0),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColor,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const FindScreen()),
                  );
                },
                child: Text(
                  S.current.addemisora,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemCount: emisoras.length,
            scrollDirection: Axis.vertical,
            onPageChanged: (index) {
              setState(() {
                currentEmisoraIndex = index;
              });
              final emisoraUrl = emisoras[index]['url'] as String;
              playEmisora(emisoraUrl);
            },
            itemBuilder: (context, index) {
              final emisora = emisoras[index];
              final bool isEmisoraPaused = !isPlaying;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    isPlaying = !isPlaying;
                    if (isPlaying) {
                      audioPlayer.play();
                    } else {
                      audioPlayer.pause();
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: DefaultTextStyle(
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).colorScheme.onBackground
                            : Theme.of(context).primaryColor,
                        fontSize: 95,
                        fontFamily:
                            isPlaying ? 'LeaugeSpartan' : 'LeaugeSpartanLite',
                      ),
                      child: AnimatedBuilder(
                        animation: _opacityAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity:
                                isEmisoraPaused ? _opacityAnimation.value : 1.0,
                            child: child,
                          );
                        },
                        child: Text(
                          emisora['name'] as String,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 36.0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              child: Icon(
                Ionicons.chevron_up_outline,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                S.current.cambiaremisora,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.tertiary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isPlaying = !isPlaying;
                        if (isPlaying) {
                          audioPlayer.play();
                        } else {
                          audioPlayer.pause();
                        }
                      });
                    },
                    icon: Icon(
                      getPlaybackIcon(),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).colorScheme.onBackground
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
