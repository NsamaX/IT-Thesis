import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/locales/localizations.dart';
import 'core/routes/routes.dart';
import 'core/themes/theme.dart';
import 'core/services/local_storage.dart'; // ignore: unused_import
import 'core/services/locator.dart';
import 'core/utils/api_config.dart';
import 'presentation/blocs/@export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ยกเลิก comment บรรทัดนี้เพื่อล้างที่เก็บข้อมูลภายในระหว่างการพัฒนา
  // final localStorageService = LocalStorageService();
  // await localStorageService.clearLocalStorageSQLite();
  // await localStorageService.clearLocalStorageSharedPreferences();
  
  await ApiConfig.loadConfig(environment: 'development');
  await setupLocator();

  final settingsCubit = locator<SettingsCubit>();
  await settingsCubit.initialize();
  final initialRoute = settingsCubit.state.firstLoad 
      ? AppRoutes.index 
      : AppRoutes.my_decks;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NFCCubit>(create: (_) => locator<NFCCubit>()),
        BlocProvider<DeckManagerCubit>(create: (_) => locator<DeckManagerCubit>()),
        BlocProvider<AppStateCubit>(create: (_) => AppStateCubit()),
        BlocProvider<SettingsCubit>(create: (_) => locator<SettingsCubit>()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: true, // แอพอยู่ระหว่างการพัฒนา
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
            initialRoute: initialRoute,
          );
        },
      ),
    );
  }
}
