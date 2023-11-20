// ignore_for_file: library_private_types_in_public_api
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../generated/l10n.dart';
import '../screens/find.dart';

class SeleccionadoView extends StatefulWidget {
  const SeleccionadoView({Key? key}) : super(key: key);

  @override
  _SeleccionadoViewState createState() => _SeleccionadoViewState();
}

class _SeleccionadoViewState extends State<SeleccionadoView> {
  List<RadioResult> savedRadios = [];
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    loadSavedRadios();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  void loadSavedRadios() async {
    final prefs = await SharedPreferences.getInstance();
    final savedRadiosData = prefs.getStringList('savedRadios');
    if (savedRadiosData != null) {
      if (_isMounted) {
        setState(() {
          savedRadios = savedRadiosData
              .map((radioData) => RadioResult.fromMap(
                  jsonDecode(radioData) as Map<String, dynamic>))
              .toList();
        });
      }
    }
  }

  void deleteRadio(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final savedRadiosData = prefs.getStringList('savedRadios');
    if (savedRadiosData != null) {
      savedRadiosData.removeAt(index);
      await prefs.setStringList('savedRadios', savedRadiosData);
      if (_isMounted) {
        setState(() {
          savedRadios.removeAt(index);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(bottom: 4, top: 50, left: 14, right: 14),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                S.current.misemisoras,
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ),
          if (savedRadios.isEmpty)
            Expanded(
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
                      S.current.nohayemisoras,
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: savedRadios.length,
                itemBuilder: (context, index) {
                  final radio = savedRadios[index];
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16.0),
                      color: Theme.of(context).primaryColor,
                      child: Icon(
                        Ionicons.trash_bin_outline,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    onDismissed: (direction) {
                      deleteRadio(index);
                    },
                    child: ListTile(
                      title: GestureDetector(
                        child: Text(
                          radio.name,
                          style: TextStyle(
                            fontSize: 28,
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const FindScreen()),
          );
        },
        child: Icon(
          Ionicons.search,
          color: Theme.of(context).colorScheme.onBackground,
        ),
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
