import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/blocs/@export.dart';
import '../../presentation/pages/@export.dart';

class AppRoutes {
  static const String index = '/';
  static const String cardDetail = '/card_detail';
  static const String myCard = '/my_card';
  static const String myDeck = '/my_deck';
  static const String newDeck = '/new_deck';
  static const String read = '/read';
  static const String search = '/search';
  static const String setting = '/setting';
  static const String signIn = '/sign_in';
  static const String track = '/track';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Index Tree
      case index:
        return MaterialPageRoute(builder: (_) => IndexPage());
      case signIn:
        return MaterialPageRoute(builder: (_) => SignInPage());
      // My Deck Tree
      case myDeck:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => BottomNavCubit(),
            child: MyDeckPage(),
          ),
        );
      case newDeck:
        return MaterialPageRoute(builder: (_) => NewDeckPage());
      case cardDetail:
        return MaterialPageRoute(
          builder: (_) => CardDetailPage(),
          settings: settings,
        );
      case track:
        return MaterialPageRoute(builder: (_) => TrackPage());
      // Read Tree
      case read:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => BottomNavCubit(),
            child: ReadPage(),
          ),
        );
      case search:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => BottomNavCubit()),
              BlocProvider(create: (_) => GameSelectionCubit()),
            ],
            child: SearchPage(),
          ),
        );
      // Setting Tree
      case setting:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => BottomNavCubit(),
            child: SettingPage(),
          ),
        );
      case myCard:
        return MaterialPageRoute(
          builder: (_) => MyCardPage(),
        );
      // 404
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
