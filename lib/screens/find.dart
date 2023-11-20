// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intsplay/screens/inicio.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../generated/l10n.dart';

class FindScreen extends StatefulWidget {
  const FindScreen({Key? key}) : super(key: key);

  @override
  State<FindScreen> createState() => _FindScreenState();
}

class _FindScreenState extends State<FindScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  late FocusNode _textFocusNode;

  @override
  void initState() {
    super.initState();
    _textFocusNode = FocusNode();

    // Solicitar el enfoque en el TextFormField
    _textFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _textFocusNode.dispose();
    super.dispose();
  }

  Future<List<RadioResult>> searchRadios(String query) async {
    final apiUrl =
        'https://nl1.api.radio-browser.info/json/stations/search?name=$query';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final results = data as List<dynamic>;
      final radioResults =
          results.map((result) => RadioResult.fromMap(result)).toList();
      return radioResults;
    } else {
      throw Exception('Error en la solicitud de API: ${response.statusCode}');
    }
  }

  void performSearch() async {
    final query = _textEditingController.text.trim();

    if (query.isNotEmpty) {
      try {
        final results = await searchRadios(query);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              results: results,
              onSave: (radioResult) async {
                final prefs = await SharedPreferences.getInstance();
                final savedRadiosData =
                    prefs.getStringList('savedRadios') ?? [];
                savedRadiosData.add(jsonEncode(radioResult.toMap()));
                prefs.setStringList('savedRadios', savedRadiosData);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const InicioScreen()),
                ); // Cerrar la página
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const InicioScreen()),
            );
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
            hintText: S.current.buscar,
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
  final List<RadioResult> results;
  final Function(RadioResult) onSave;

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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const InicioScreen()),
            );
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
              padding: const EdgeInsets.only(
                  top: 20, right: 12, left: 12, bottom: 14),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.name,
                    style: TextStyle(
                      fontSize: 30,
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

class RadioResult {
  final String name;
  final String url;

  RadioResult({
    required this.name,
    required this.url,
  });

  factory RadioResult.fromMap(Map<String, dynamic> map) {
    return RadioResult(
      name: map['name'] as String,
      url: map['url'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
    };
  }
}
