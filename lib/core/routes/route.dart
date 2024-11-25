import 'package:flutter/material.dart';
import '../../presentation/pages/export.dart';

class AppRoutes {
  // Index Tree
  static const String index = '/';
  static const String signIn = '/sign_in';
  // Deck Tree
  static const String myDeck = '/my_deck';
  static const String newDeck = '/new_deck';
  static const String track = '/track';
  // Read Tree
  static const String read = '/read';
  static const String search = '/search';
  static const String other = '/other';
  static const String cardInfo = '/card_info';
  // Setting Tree
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
      case newDeck:
        return MaterialPageRoute(builder: (_) => NewDeckPage());
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
      case cardInfo:
        return MaterialPageRoute(
          builder: (_) => CardInfoPage(),
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
