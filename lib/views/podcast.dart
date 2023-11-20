import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intsplay/views/buscar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PodcastsView extends StatefulWidget {
  const PodcastsView({Key? key}) : super(key: key);

  @override
  State<PodcastsView> createState() => _PodcastsViewState();
}

class _PodcastsViewState extends State<PodcastsView> {
  late List<PodcastResult> savedPodcasts = [];

  @override
  void initState() {
    super.initState();
    loadSavedPodcasts();
  }

  Future<void> loadSavedPodcasts() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPodcastsData = prefs.getStringList('savedPodcasts') ?? [];
    setState(() {
      savedPodcasts = savedPodcastsData
          .map((data) => PodcastResult.fromMap(jsonDecode(data)))
          .toList();
    });
  }

  Future<void> deletePodcast(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final savedPodcastsData = prefs.getStringList('savedPodcasts') ?? [];
    savedPodcastsData.removeAt(index);
    prefs.setStringList('savedPodcasts', savedPodcastsData);
    loadSavedPodcasts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Ionicons.arrow_back_outline,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Ionicons.add_outline,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BuscarScreen(),
                ),
              );
            },
          )
        ],
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Center(
          child: Image.asset(
            Theme.of(context).brightness == Brightness.dark
                ? "assets/images/ints-oscuro.png"
                : "assets/images/ints-blanco.png",
            height: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 20, top: 50, left: 14, right: 14),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Mis pódcasts',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            // Envuelve el ListView.builder con Expanded
            child: Container(
              child: savedPodcasts.isEmpty
                  ? Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 80),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              Theme.of(context).brightness == Brightness.dark
                                  ? "assets/images/planetario-oscuro.png"
                                  : "assets/images/planetario-claro.png",
                            ),
                            Text(
                              'No hay pódcasts guardados',
                              style: TextStyle(
                                fontSize: 24,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: savedPodcasts.length,
                      itemBuilder: (context, index) {
                        final podcast = savedPodcasts[index];
                        return Dismissible(
                          key: UniqueKey(),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16.0),
                            color: Theme.of(context).primaryColor,
                            child: Icon(
                              Ionicons.trash_bin_outline,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => deletePodcast(index),
                          child: ListTile(
                            title: Text(
                              podcast.title,
                              style: TextStyle(
                                fontSize: 28,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            subtitle: Container(
                              margin: const EdgeInsets.only(top: 7),
                              child: Text(
                                podcast.author,
                                style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class PodcastResult {
  final String id;
  final String title;
  final String author;
  final String rss;

  PodcastResult({
    required this.id,
    required this.title,
    required this.author,
    required this.rss,
  });

  factory PodcastResult.fromMap(Map<String, dynamic> map) {
    return PodcastResult(
      id: map['collectionId'].toString(),
      title: map['collectionName'] as String,
      author: map['artistName'] as String,
      rss: map['feedUrl'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'collectionId': id,
      'collectionName': title,
      'artistName': author,
      'feedUrl': rss,
    };
  }
}
