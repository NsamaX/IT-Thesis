import 'package:flutter/material.dart';
import 'package:nfc_project/presentation/pages/@export.dart';

class AppRoutes {
  static const String index   = '/';
  static const String signIn  = '/sign_in';
  static const String myDecks = '/my_decks';
  static const String newDeck = '/new_deck';
  static const String tracker = '/tracker';
  static const String scan    = '/scan';
  static const String games   = '/games';
  static const String search  = '/search';
  static const String card    = '/card';
  static const String setting = '/setting';
  static const String library = '/library';
  static const String about   = '/about';
  static const String privacy = '/privacy';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routes = <String, WidgetBuilder>{
      index:   (_) => IndexPage(),
      signIn:  (_) => SignInPage(),
      myDecks: (_) => MyDecksPage(),
      newDeck: (_) => NewDeckPage(),
      tracker: (_) => TrackerPage(),
      scan:    (_) => ReaderPage(),
      games:   (_) => GamesPage(),
      search:  (_) => SearchPage(),
      card:    (_) => CardPage(),
      setting: (_) => SettingsPage(),
      library: (_) => LibraryPage(),
      about:   (_) => AboutPage(),
      privacy: (_) => PrivacyPage(),
    };
    WidgetBuilder builder = routes[settings.name] ?? (_) => Scaffold(
      body: Center(child: Text('No route defined for ${settings.name}')),
    );
    return MaterialPageRoute(builder: builder, settings: settings);
  }
}
