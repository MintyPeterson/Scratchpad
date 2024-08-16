import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scratchpad/notes_page.dart';
import 'package:scratchpad/text_localisations.dart';

/// A widget that provides the application.
class Scratchpad extends StatelessWidget {
  const Scratchpad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      onGenerateTitle: (context) => TextLocalisations.of(context).title,
      localizationsDelegates: const [
        TextLocalisationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
      ],
      home: const NotesPage(),
    );
  }
}
