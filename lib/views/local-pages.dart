// ignore_for_file: file_names, depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ionicons/ionicons.dart';
import 'package:just_audio/just_audio.dart';

import '../screens/inicio.dart';

class LocalPageView extends StatefulWidget {
  const LocalPageView({Key? key}) : super(key: key);

  @override
  State<LocalPageView> createState() => _LocalPageViewState();
}

class _LocalPageViewState extends State<LocalPageView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  List<Emisora> emisoras = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0.50, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
    _animationController.repeat(reverse: true);
    loadEmisoras();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> loadEmisoras() async {
    final response = await http.get(Uri.parse('https://intsplay.com/pr.txt'));

    if (response.statusCode == 200) {
      final data = response.body;
      final jsonData = json.decode(data);
      final emisorasData = jsonData as List<dynamic>;

      setState(() {
        emisoras = emisorasData
            .map((emisoraData) => Emisora.fromJson(emisoraData))
            .toList();
      });
    }
  }

  Future<void> playAudio(String url) async {
    try {
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    } catch (e) {
      // Error handling
    }
  }

  void onPageChanged(int index) {
    setState(() {
      currentPageIndex = index;
      final emisora = emisoras[currentPageIndex];
      playAudio(emisora.enlace);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _opacityAnimation,
                builder: (context, child) {
                  return PageView.builder(
                    itemCount: emisoras.length,
                    itemBuilder: (context, index) {
                      final emisora = emisoras[index];
                      return Center(
                        child: Opacity(
                          opacity: _opacityAnimation.value,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                emisora.frecuencia,
                                style: TextStyle(
                                  fontSize: 135,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                      : Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    onPageChanged: onPageChanged,
                  );
                },
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InicioScreen()),
                  );
                },
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 45),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Icon(
                        Ionicons.power,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class Emisora {
  final String nombre;
  final String frecuencia;
  final String enlace;

  Emisora({
    required this.nombre,
    required this.frecuencia,
    required this.enlace,
  });

  factory Emisora.fromJson(Map<String, dynamic> json) {
    return Emisora(
      nombre: json['nombre'],
      frecuencia: json['frecuencia'].toString(),
      enlace: json['enlace'],
    );
  }
}
