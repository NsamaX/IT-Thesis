// Flutter packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project packages
import 'core/locales/localizations.dart';
import 'core/routes/route.dart';
import 'core/themes/@theme.dart';
import 'core/service_locator.dart';
import 'data/datasources/remote/api_config.dart';
import 'presentation/blocs/app_state.dart';
import 'presentation/blocs/deck_manager.dart';
import 'presentation/blocs/locale.dart';
import 'presentation/blocs/NFC.dart';

Future<void> clearLocalStorage() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('Local storage cleared successfully!');
  } catch (e) {
    print('Error clearing local storage: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  try {
    // await clearLocalStorage();
    await ApiConfig.loadConfig(environment: 'development');
    await setupLocator();
    await locator<LocaleCubit>().loadLanguage();
    runApp(MyApp());
  } catch (e) {
    print('Error initializing API Config: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DeckManagerCubit>(create: (_) => locator<DeckManagerCubit>()),
        BlocProvider<NFCCubit>(create: (_) => locator<NFCCubit>()),
        BlocProvider<AppStateCubit>(create: (_) => AppStateCubit()),
        BlocProvider<LocaleCubit>(create: (_) => locator<LocaleCubit>()),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: true,
            locale: state.locale,
            supportedLocales: [
              Locale('en'),
              Locale('ja'),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: themeData(),
            onGenerateRoute: AppRoutes.generateRoute,
            initialRoute: AppRoutes.index,
          );
        },
      ),
    );
  }
}
