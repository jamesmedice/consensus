import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/authentication_wrapper.dart';
import 'locator.dart';
import 'l18n.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setupServices();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MeinApp(prefs));
}

class MeinApp extends StatelessWidget {
  final SharedPreferences prefs;

  MeinApp(this.prefs);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consensus',
      theme: ThemeData(primarySwatch: Colors.teal),
      supportedLocales: [Locale('en', 'US'), Locale('pt', 'PT')],
      localizationsDelegates: [
        const AppLocalizationsDelegate(defaultLocale: Locale('pt')),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: AuthenticationWrapper(this.prefs),
    );
  }
}
