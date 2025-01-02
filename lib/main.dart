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

// ignore: unused_import
import 'package:shared_preferences/shared_preferences.dart';

/// ฟังก์ชันเริ่มต้นของแอป
void main() async { 
  // เตรียมการใช้งาน Flutter
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // กำหนดให้แอปทำงานเฉพาะในแนวตั้ง
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // สำหรับทดสอบการล้าง Shared Preferences
    // final pref = await SharedPreferences.getInstance();
    // pref.clear();

    // ตั้งค่า Service Locator และโหลดการตั้งค่า API
    await setupLocator();
    await ApiConfig.loadConfig(environment: 'development');

    // ดึง SettingsCubit และโหลดค่าการตั้งค่า
    final settingsCubit = locator<SettingsCubit>();
    await settingsCubit.initialize();

    // กำหนดเส้นทางเริ่มต้นของแอป
    final initialRoute = settingsCubit.state.firstLoad
        ? AppRoutes.index
        : AppRoutes.my_decks;

    // เรียกใช้งานแอป
    runApp(MyApp(initialRoute: initialRoute));
  } catch (e, stackTrace) {
    // แสดงข้อผิดพลาดในกรณีที่เกิดปัญหาระหว่างการเริ่มต้น
    debugPrint('Error occurred during app initialization: $e');
    debugPrint(stackTrace.toString());
  }
}

/// คลาสหลักของแอป
class MyApp extends StatelessWidget { 
  // เส้นทางเริ่มต้นของแอป
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // ลงทะเบียน Cubit ต่าง ๆ ในแอป
        BlocProvider<NFCCubit>(create: (_) => locator<NFCCubit>()),
        BlocProvider<DeckManagerCubit>(create: (_) => locator<DeckManagerCubit>()),
        BlocProvider<AppStateCubit>(create: (_) => AppStateCubit()),
        BlocProvider<SettingsCubit>(create: (_) => locator<SettingsCubit>()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: true,
            locale: state.locale,
            supportedLocales: [
              Locale('en'),
              Locale('ja'),
            ], // ภาษาที่แอปรองรับ
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ], // การตั้งค่าภาษา
            theme: themeData(), // ธีมของแอป
            onGenerateRoute: AppRoutes.generateRoute, // การกำหนดเส้นทางในแอป
            initialRoute: initialRoute, // เส้นทางเริ่มต้น
          );
        },
      ),
    );
  }
}
