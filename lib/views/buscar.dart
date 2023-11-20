// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuscarScreen extends StatefulWidget {
  const BuscarScreen({Key? key}) : super(key: key);

  @override
  State<BuscarScreen> createState() => _BuscarScreenState();
}

class _BuscarScreenState extends State<BuscarScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  late FocusNode _textFocusNode;

  @override
  void initState() {
    super.initState();
    _textFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _textFocusNode.dispose();
    super.dispose();
  }

  Future<List<PodcastResult>> searchPodcasts(String query) async {
    final apiUrl = 'https://itunes.apple.com/search?media=podcast&term=$query';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final results = data['results'] as List<dynamic>;
      final podcastResults =
          results.map((result) => PodcastResult.fromMap(result)).toList();
      return podcastResults;
    } else {
      throw Exception('Error en la solicitud de API: ${response.statusCode}');
    }
  }

  void performSearch() async {
    final query = _textEditingController.text.trim();

    if (query.isNotEmpty) {
      try {
        final results = await searchPodcasts(query);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              results: results,
              onSave: (podcastResult) async {
                final prefs = await SharedPreferences.getInstance();
                final savedPodcastsData =
                    prefs.getStringList('savedPodcasts') ?? [];
                savedPodcastsData.add(jsonEncode(podcastResult.toMap()));
                prefs.setStringList('savedPodcasts', savedPodcastsData);
                Navigator.pop(
                  context,
                );
              },
            ),
          ),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Ionicons.arrow_back,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        elevation: 0,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: TextFormField(
          controller: _textEditingController,
          focusNode: _textFocusNode,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            hintText: 'Buscar aquí',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 50,
              height: 1.3,
              fontFamily: 'LeaugeSpartanLite',
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(27),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(27),
              borderSide: BorderSide.none,
            ),
          ),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 50,
            height: 1.3,
            fontFamily: 'LeaugeSpartanLite',
          ),
          maxLines: null,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (value) {
            performSearch();
          },
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final List<PodcastResult> results;
  final Function(PodcastResult) onSave;

  const ResultScreen({
    Key? key,
    required this.results,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Ionicons.arrow_back,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          return GestureDetector(
            onTap: () {
              onSave(result);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.title,
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.author,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.rss,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
