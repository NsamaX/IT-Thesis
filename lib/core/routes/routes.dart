import 'package:flutter/material.dart';
import 'package:nfc_project/presentation/pages/@export.dart';

class AppRoutes {
  static const String index     = '/';
  static const String signIn    = '/sign_in';
  static const String my_decks  = '/my_decks';
  static const String new_deck  = '/new_deck';
  static const String tracker   = '/tracker';
  static const String games     = '/games';
  static const String scan      = '/scan';
  static const String search    = '/search';
  static const String about     = '/about';
  static const String card      = '/card';
  static const String library   = '/library';
  static const String privacy   = '/privacy';
  static const String setting   = '/setting';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case index:
        return MaterialPageRoute(builder: (_) => IndexPage());
      case signIn:
        return MaterialPageRoute(builder: (_) => SignInPage());
      case my_decks:
        return MaterialPageRoute(builder: (_) => MyDecksPage());
      case new_deck:
        return MaterialPageRoute(builder: (_) => NewDeckPage());
      case tracker:
        return MaterialPageRoute(builder: (_) => TrackerPage());
      case games:
        return MaterialPageRoute(builder: (_) => GamesPage(), settings: settings);
      case scan:
        return MaterialPageRoute(builder: (_) => ReaderPage());
      case search:
        return MaterialPageRoute(builder: (_) => SearchPage(), settings: settings);
      case about:
        return MaterialPageRoute(builder: (_) => AboutPage());
      case card:
        return MaterialPageRoute(builder: (_) => CardPage(), settings: settings);
      case library:
        return MaterialPageRoute(builder: (_) => LibraryPage());
      case privacy:
        return MaterialPageRoute(builder: (_) => PrivacyPage());
      case setting:
        return MaterialPageRoute(builder: (_) => SettingsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
