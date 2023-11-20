// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Change station by sliding up`
  String get cambiaremisora {
    return Intl.message(
      'Change station by sliding up',
      name: 'cambiaremisora',
      desc: '',
      args: [],
    );
  }

  /// `My stations`
  String get misemisoras {
    return Intl.message(
      'My stations',
      name: 'misemisoras',
      desc: '',
      args: [],
    );
  }

  /// `Search here`
  String get buscar {
    return Intl.message(
      'Search here',
      name: 'buscar',
      desc: '',
      args: [],
    );
  }

  /// `No saved stations`
  String get nohayemisoras {
    return Intl.message(
      'No saved stations',
      name: 'nohayemisoras',
      desc: '',
      args: [],
    );
  }

  /// `Get INTS PLAY SIGNAL`
  String get obtensignal {
    return Intl.message(
      'Get INTS PLAY SIGNAL',
      name: 'obtensignal',
      desc: '',
      args: [],
    );
  }

  /// `Search for a station`
  String get buscaremisora {
    return Intl.message(
      'Search for a station',
      name: 'buscaremisora',
      desc: '',
      args: [],
    );
  }

  /// `Hello, my name is Ints!`
  String get saludo {
    return Intl.message(
      'Hello, my name is Ints!',
      name: 'saludo',
      desc: '',
      args: [],
    );
  }

  /// `Add a station`
  String get addemisora {
    return Intl.message(
      'Add a station',
      name: 'addemisora',
      desc: '',
      args: [],
    );
  }

  /// `Add a station to start this adventure!`
  String get descripcionaddemisora {
    return Intl.message(
      'Add a station to start this adventure!',
      name: 'descripcionaddemisora',
      desc: '',
      args: [],
    );
  }

  /// `To KP4-LRA, from Emmanuel`
  String get titulokp4 {
    return Intl.message(
      'To KP4-LRA, from Emmanuel',
      name: 'titulokp4',
      desc: '',
      args: [],
    );
  }

  /// ` After so much work and sacrifice, today I have finished this small piece of us for humanity. That's why I dedicate it to you, wherever you are. You were the reason I fell in love with technology, the reason I became passionate about radio, and the reason I loved to keep everything in its place. You were the only person who, amidst everything, listened to me. You were my hero in my childhood, not just mine, but also my mom's, your talented daughter. You asked me to spread the word of God. I promised you, and through this means, I fulfill my word. Thank you for being my hero. From this earthly plane, with my hand on my heart, together with family, your colleagues, and all those you impacted with your being, I thank you. Some called you KP4-LRA, but today, I call you abuelo.`
  String get contenidokp4 {
    return Intl.message(
      ' After so much work and sacrifice, today I have finished this small piece of us for humanity. That\'s why I dedicate it to you, wherever you are. You were the reason I fell in love with technology, the reason I became passionate about radio, and the reason I loved to keep everything in its place. You were the only person who, amidst everything, listened to me. You were my hero in my childhood, not just mine, but also my mom\'s, your talented daughter. You asked me to spread the word of God. I promised you, and through this means, I fulfill my word. Thank you for being my hero. From this earthly plane, with my hand on my heart, together with family, your colleagues, and all those you impacted with your being, I thank you. Some called you KP4-LRA, but today, I call you abuelo.',
      name: 'contenidokp4',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'eo'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
