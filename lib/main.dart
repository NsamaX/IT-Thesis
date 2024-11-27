// Flutter packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project packages
import 'core/locales/localizations.dart';
import 'core/routes/route.dart';
import 'core/themes/@theme.dart';
import 'data/datasources/remote/api_config.dart';
import 'data/repositories/deck.dart';
import 'domain/usecases/deck_manager.dart';
import 'presentation/blocs/deck_manager.dart';
import 'presentation/blocs/locale.dart';
import 'presentation/blocs/NFC.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleCubit>(create: (context) => LocaleCubit()),
        BlocProvider(create: (context) => NFCCubit()),
        BlocProvider(
          create: (context) => DeckManagerCubit(
            addCardUseCase: AddCardUseCase(),
            removeCardUseCase: RemoveCardUseCase(),
            saveDeckUseCase: SaveDeckUseCase(DeckRepository()),
            deleteDeckUseCase: DeleteDeckUseCase(DeckRepository()),
            loadDecksUseCase: LoadDecksUseCase(DeckRepository()),
          ),
        ),
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
