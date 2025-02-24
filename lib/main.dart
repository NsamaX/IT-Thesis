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

// debug mode
// import 'package:nfc_project/core/services/database.dart';

/*------------------------------------------------------------------------------
 |  ฟังก์ชัน main
 |
 |  วัตถุประสงค์:
 |      เริ่มต้นการทำงานของแอปพลิเคชัน และตั้งค่าพื้นฐานก่อนเปิดแอป
 *----------------------------------------------------------------------------*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Debugging: ใช้เพื่อดูโครงสร้างของตารางในฐานข้อมูล
  // await DatabaseService().printTables(); // Uncomment for debugging

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await AppLocalizations.loadSupportedLanguages();
  await ApiConfig.loadConfig(environment: 'development');
  await setupLocator();

  runApp(const MyApp());
}

/*------------------------------------------------------------------------------
 |  คลาส MyApp
 |
 |  วัตถุประสงค์:
 |      กำหนดโครงสร้างของแอปพลิเคชัน และการตั้งค่าธีม / ภาษา
 *----------------------------------------------------------------------------*/
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
    future: _initializeApp(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return _buildLoadingScreen();
      }
      if (snapshot.hasError) {
        return _buildErrorScreen(snapshot.error);
      }
      return _buildApp();
    },
  );

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน _initializeApp
   |
   |  วัตถุประสงค์:
   |      โหลดค่าการตั้งค่าเริ่มต้นของแอปผ่าน SettingsCubit
   |
   |  ค่าที่คืนกลับ:
   |      - Future<void>
   *--------------------------------------------------------------------------*/
  Future<void> _initializeApp() async => await locator<SettingsCubit>().initialize();

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน _buildLoadingScreen
   |
   |  วัตถุประสงค์:
   |      แสดงหน้าจอ Loading ระหว่างที่แอปกำลังเริ่มต้น
   *--------------------------------------------------------------------------*/
  Widget _buildLoadingScreen() => const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(child: CircularProgressIndicator()),
    ),
  );

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน _buildErrorScreen
   |
   |  วัตถุประสงค์:
   |      แสดงหน้าจอ Error เมื่อแอปพลิเคชันไม่สามารถโหลดค่าตั้งต้นได้
   |
   |  พารามิเตอร์:
   |      error (IN) -- ข้อความ error ที่เกิดขึ้น
   *--------------------------------------------------------------------------*/
  Widget _buildErrorScreen(Object? error) => MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(
        child: Text(
          'Error initializing app: $error',
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน _buildApp
   |
   |  วัตถุประสงค์:
   |      คืนค่า MultiBlocProvider ที่ห่อหุ้ม MaterialApp
   *--------------------------------------------------------------------------*/
  Widget _buildApp() => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => locator<NFCCubit>()),
      BlocProvider(create: (_) => locator<CollectionCubit>()),
      BlocProvider(create: (_) => locator<DeckManagerCubit>()),
      BlocProvider(create: (_) => locator<SettingsCubit>()),
      BlocProvider(create: (_) => AppCubit()),
    ],
    child: BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) => MaterialApp(
        debugShowCheckedModeBanner: true,
        locale: state.locale,
        supportedLocales: _supportedLocales,
        localizationsDelegates: _localizationsDelegates,
        theme: themeData(isDarkMode: state.isDarkMode),
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: _getInitialRoute(state),
        navigatorObservers: [locator<RouteObserver<ModalRoute>>()],
      ),
    ),
  );

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน _getInitialRoute
   |
   |  วัตถุประสงค์:
   |      กำหนดเส้นทางเริ่มต้นของแอป
   |
   |  พารามิเตอร์:
   |      state (IN) -- State ของ SettingsCubit
   |
   |  ค่าที่คืนกลับ:
   |      - String ที่ระบุเส้นทางเริ่มต้น
   *--------------------------------------------------------------------------*/
  String _getInitialRoute(SettingsState state) => state.firstLoad ? AppRoutes.index : AppRoutes.myDecks;

  /*----------------------------------------------------------------------------
   |  ค่าคงที่ _supportedLocales
   |
   |  วัตถุประสงค์:
   |      กำหนดรายการภาษาที่รองรับในแอป
   *--------------------------------------------------------------------------*/
  static final List<Locale> _supportedLocales = AppLocalizations.supportedLanguages.map((lang) => Locale(lang)).toList();

  /*----------------------------------------------------------------------------
   |  ค่าคงที่ _localizationsDelegates
   |
   |  วัตถุประสงค์:
   |      กำหนดรายการ Localizations Delegates ที่แอปรองรับ
   *--------------------------------------------------------------------------*/
  static const _localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}
