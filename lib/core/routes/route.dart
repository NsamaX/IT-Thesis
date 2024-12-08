import 'package:flutter/material.dart';
import 'package:nfc_project/presentation/pages/@export.dart';

class AppRoutes {
  static const String index     = '/';
  static const String signIn    = '/sign_in';
  static const String decks     = '/decks';
  static const String builder   = '/builder';
  static const String tracker   = '/tracker';
  static const String reader    = '/reader';
  static const String games     = '/games';
  static const String search    = '/search';
  static const String setting   = '/setting';
  static const String library   = '/library';
  static const String card      = '/card';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case index:
        return MaterialPageRoute(builder: (_) => IndexPage());
      case signIn:
        return MaterialPageRoute(builder: (_) => SignInPage());
      case decks:
        return MaterialPageRoute(builder: (_) => DecksPage());
      case builder:
        return MaterialPageRoute(builder: (_) => BuilderPage());
      case tracker:
        return MaterialPageRoute(builder: (_) => TrackerPage());
      case reader:
        return MaterialPageRoute(builder: (_) => ReaderPage());
      case games:
        return MaterialPageRoute(builder: (_) => GamesPage(), settings: settings);
      case search:
        return MaterialPageRoute(builder: (_) => SearchPage(), settings: settings);
      case setting:
        return MaterialPageRoute(builder: (_) => SettingsPage());
      case library:
        return MaterialPageRoute(builder: (_) => LibraryPage());
      case card:
        return MaterialPageRoute(builder: (_) => CardPage(), settings: settings);
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
