// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intsplay/screens/inicio.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      S.delegate,
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const InicioScreen(),
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8F8F8),
        primaryColor: const Color(0xFFFF6C17),
        colorScheme: const ColorScheme.light(
          background: Color(0xFFE1E1E1),
          onBackground: Color(0xFF171717),
          secondary: Color(0xFF424242),
          onSecondary: Color(0xFF171717),
          tertiary: Color(0xFFFFFFFF),
          // ignore: use_full_hex_values_for_flutter_colors
          onTertiary: Color.fromARGB(180, 255, 255, 255),
        ),
        fontFamily: 'LeaugeSpartanLite',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        primaryColor: const Color(0xFFFF6C17),
        colorScheme: const ColorScheme.dark(
          background: Color(0xFF171717),
          onBackground: Color(0xFFF8F8F8),
          secondary: Color(0xFFCACACA),
          onSecondary: Color(0xFFF8F8F8),
          tertiary: Color(0xFF282828),
          // ignore: use_full_hex_values_for_flutter_colors
          onTertiary: Color.fromARGB(180, 40, 40, 40),
        ),
        fontFamily: 'LeaugeSpartanLite',
      ),
      themeMode: ThemeMode.system,
      localizationsDelegates: localizationsDelegates,
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
        Locale('eo', ''),
      ],
    );
  }
}
