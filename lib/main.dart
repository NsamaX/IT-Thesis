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

void main() async {
  // เตรียม Widgets ก่อนเริ่มแอป
  WidgetsFlutterBinding.ensureInitialized();

  // ล็อคหน้าจอแนวตั้ง
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // โหลดการตั้งค่าของ API
  await ApiConfig.loadConfig();

  // เริ่มต้นแอปพลิเคชัน
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // กำหนด Bloc ที่จะใช้ในแอป
      providers: [
        BlocProvider<LocaleCubit>(create: (context) => LocaleCubit()), // ภาษา
        BlocProvider(
            create: (context) => DeckManagerCubit(
                  addCardUseCase: AddCardUseCase(),
                  removeCardUseCase: RemoveCardUseCase(),
                  saveDeckUseCase: SaveDeckUseCase(DeckRepository()),
                  deleteDeckUseCase: DeleteDeckUseCase(DeckRepository()),
                  loadDecksUseCase: LoadDecksUseCase(DeckRepository()),
                )), // การจัดการเด็ค
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, state) {
          return MaterialApp(
            // แสดง debug banner ในแอปสำหรับช่วงพัฒนา
            debugShowCheckedModeBanner: true,

            // การตั้งค่าภาษา
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

            // การตั้งค่าธีม
            theme: themeData(),

            onGenerateRoute: AppRoutes.generateRoute, // การตั้งค่าเส้นทาง
            initialRoute: AppRoutes.index, // เส้นทางเริ่มต้น
          );
        },
      ),
    );
  }
}
