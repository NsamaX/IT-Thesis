import 'package:flutter/material.dart';

import 'package:nfc_project/presentation/pages/@export.dart';

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
class AppRoutes {
  static const String index    = '/';
  static const String signIn   = '/sign_in';
  static const String myDecks  = '/my_decks';
  static const String newDeck  = '/new_deck';
  static const String tracker  = '/tracker';
  static const String read     = '/read';
  static const String games    = '/games';
  static const String search   = '/search';
  static const String card     = '/card';
  static const String setting  = '/setting';
  static const String library  = '/library';
  static const String about    = '/about';
  static const String privacy  = '/privacy';
  static const String language = '/language';

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case index:    page = IndexPage();    break;
      case signIn:   page = SignInPage();   break;
      case myDecks:  page = MyDecksPage();  break;
      case newDeck:  page = NewDeckPage();  break;
      case tracker:  page = TrackerPage();  break;
      case read:     page = ReadPage();     break;
      case games:    page = GamePage();     break;
      case search:   page = SearchPage();   break;
      case card:     page = CardPage();     break;
      case setting:  page = SettingsPage(); break;
      case library:  page = LibraryPage();  break;
      case about:    page = AboutPage();    break;
      case privacy:  page = PrivacyPage();  break;
      case language: page = LanguagePage(); break;
      default:       page = _defaultRoute(settings.name);
    }
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }

  /*--------------------------------------------------------------------------------
   |
   |
   |
   |
   |
   |
   |
   |
   |
   |
   *-------------------------------------------------------------------------------*/
  static Widget _defaultRoute(String? routeName) => Scaffold(
    body: Center(child: Text('No route defined for $routeName')),
  );
}
