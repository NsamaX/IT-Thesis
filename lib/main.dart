import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/api_config.dart';
import 'core/locales/localizations.dart';
import 'core/routes/routes.dart';
import 'core/services/locator.dart';
import 'core/themes/theme.dart';
import 'presentation/cubits/@export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await setupLocator();
  await ApiConfig.loadConfig(environment: 'development');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Text(
                  'Error initializing app: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => locator<NFCCubit>()),
            BlocProvider(create: (_) => locator<DeckManagerCubit>()),
            BlocProvider(create: (_) => AppCubit()),
            BlocProvider(create: (_) => locator<SettingsCubit>()),
          ],
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: true,
                locale: state.locale,
                supportedLocales: const [Locale('en'), Locale('ja')],
                localizationsDelegates: _localizationsDelegates,
                theme: themeData(isDarkMode: state.isDarkMode),
                onGenerateRoute: AppRoutes.generateRoute,
                initialRoute: _getInitialRoute(state),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _initializeApp() async {
    final settingsCubit = locator<SettingsCubit>();
    await settingsCubit.initialize();
  }

  String _getInitialRoute(SettingsState state) {
    return state.firstLoad ? AppRoutes.index : AppRoutes.myDecks;
  }

  static const _localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}
