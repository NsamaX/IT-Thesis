import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '@export.dart';
import 'package:nfc_project/data/datasources/local/@export.dart';
import 'package:nfc_project/data/datasources/remote/@export.dart';
import 'package:nfc_project/data/repositories/@export.dart';
import 'package:nfc_project/domain/usecases/@export.dart';
import 'package:nfc_project/presentation/cubits/@export.dart';

/// ตัวจัดการ Dependency Injection ด้วย GetIt
final GetIt locator = GetIt.instance;

/// ตั้งค่าตัวจัดการ Dependency Injection
Future<void> setupLocator() async {
  //--------------------------------- ฐานข้อมูล --------------------------------//
  locator.registerLazySingleton(() => DatabaseService());
  final databaseService = locator<DatabaseService>();

  final sqliteService = SQLiteService(databaseService);
  locator.registerLazySingleton(() => sqliteService);

  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => SharedPreferencesService(sharedPreferences));

  //---------------------------- Local DataSource ----------------------------//
  locator.registerLazySingleton<CardLocalDataSource>(() => CardLocalDataSourceImpl(locator<SQLiteService>()));

  locator.registerLazySingleton<SettingsLocalDataSource>(() => SettingsLocalDataSourceImpl(locator<SharedPreferencesService>()));
  locator.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(locator<SettingsLocalDataSource>()));

  locator.registerLazySingleton(() => LoadSetting(locator<SettingsRepository>()));
  locator.registerLazySingleton(() => SaveSetting(locator<SettingsRepository>()));
  locator.registerLazySingleton(() => SettingsCubit(
        loadSetting: locator<LoadSetting>(),
        saveSetting: locator<SaveSetting>(),
      ));

  //------------------------------- สถานะของแอป ------------------------------//
  locator.registerLazySingleton(() => AppStateCubit());

  //------------------------------- การ์ดจาก API ------------------------------//
  locator.registerFactoryParam<GameApi, String, void>((game, _) {
    return GameFactory.createApi(game);
  });
  locator.registerFactoryParam<CardRepository, String, void>((game, _) {
    final gameApi = locator<GameApi>(param1: game);
    final cardLocalDataSource = locator<CardLocalDataSource>();
    return CardRepositoryImpl(gameApi: gameApi, cardLocalDataSource: cardLocalDataSource);
  });

  locator.registerFactoryParam<SyncCardsUseCase, String, void>((game, _) {
    final cardRepository = locator<CardRepository>(param1: game);
    return SyncCardsUseCase(cardRepository);
  });

  //--------------------------------- สำรับการ์ด -------------------------------//
  locator.registerLazySingleton<DeckLocalDataSource>(() => DeckLocalDataSourceImpl(locator<SQLiteService>()));
  locator.registerLazySingleton<DeckRepository>(() => DeckRepositoryImpl(locator<DeckLocalDataSource>()));

  locator.registerLazySingleton(() => AddCardUseCase());
  locator.registerLazySingleton(() => RemoveCardUseCase());
  locator.registerLazySingleton(() => LoadDecksUseCase(locator<DeckRepository>()));
  locator.registerLazySingleton(() => SaveDeckUseCase(locator<DeckRepository>()));
  locator.registerLazySingleton(() => DeleteDeckUseCase(locator<DeckRepository>()));
  locator.registerFactory(() => DeckManagerCubit(
        addCardUseCase: locator<AddCardUseCase>(),
        removeCardUseCase: locator<RemoveCardUseCase>(),
        loadDecksUseCase: locator<LoadDecksUseCase>(),
        saveDeckUseCase: locator<SaveDeckUseCase>(),
        deleteDeckUseCase: locator<DeleteDeckUseCase>(),
      ));

  //----------------------------------- NFC ----------------------------------//
  locator.registerLazySingleton(() => NFCCubit());
  locator.registerLazySingleton(() => ScanHistoryCubit());
}
