// flutter packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// project packages
import 'core/locales/localizations.dart';
import 'core/routes/route.dart';
import 'core/themes/@theme.dart';
import 'data/datasources/remote/api_config.dart';
import 'presentation/blocs/locale.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await ApiConfig.loadConfig();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocaleCubit(),
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
