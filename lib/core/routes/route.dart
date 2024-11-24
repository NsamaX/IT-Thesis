import 'package:flutter/material.dart';
import '../../presentation/pages/export.dart';

class AppRoutes {
  static const String index = '/';
  static const String signIn = '/sign_in';
  static const String myDeck = '/my_deck';
  static const String deck = '/deck';
  static const String cardDetail = '/card_detail';
  static const String track = '/track';
  static const String read = '/read';
  static const String search = '/search';
  static const String other = '/other';
  static const String setting = '/setting';
  static const String myCard = '/my_card';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Index Tree
      case index:
        return MaterialPageRoute(builder: (_) => IndexPage());
      case signIn:
        return MaterialPageRoute(builder: (_) => SignInPage());
      // Deck Tree
      case myDeck:
        return MaterialPageRoute(builder: (_) => MyDeckPage());
      case deck:
        return MaterialPageRoute(builder: (_) => DeckPage());
      case cardDetail:
        return MaterialPageRoute(
          builder: (_) => CardDetailPage(),
          settings: settings,
        );
      case track:
        return MaterialPageRoute(builder: (_) => TrackPage());
      // Read Tree
      case read:
        return MaterialPageRoute(builder: (_) => ReadPage());
      case search:
        return MaterialPageRoute(
          builder: (_) => SearchPage(),
          settings: settings,
        );
      case other:
        return MaterialPageRoute(
          builder: (_) => OtherPage(),
          settings: settings,
        );
      // Setting Tree
      case setting:
        return MaterialPageRoute(builder: (_) => SettingPage());
      case myCard:
        return MaterialPageRoute(builder: (_) => MyCardPage());
      // 404
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
