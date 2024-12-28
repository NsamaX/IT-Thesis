import 'package:get_it/get_it.dart';
import '@export.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nfc_project/data/datasources/local/@export.dart';
import 'package:nfc_project/data/datasources/remote/@export.dart';
import 'package:nfc_project/data/repositories/@export.dart';
import 'package:nfc_project/domain/usecases/@export.dart';
import 'package:nfc_project/presentation/cubits/@export.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // ตัวจัดการฐานข้อมูล
  locator.registerLazySingleton(() => DatabaseService());
  final databaseService = locator<DatabaseService>();

  // ตัวจัดการ SQLite
  final sqliteService = SQLiteService(databaseService);
  locator.registerLazySingleton(() => sqliteService);

  // ตัวจัดการ Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => SharedPreferencesService(sharedPreferences));

  // ตัวจัดการ Local DataSource สำหรับการ์ด
  locator.registerLazySingleton<CardLocalDataSource>(() => CardLocalDataSourceImpl(locator<SQLiteService>()));

  // ตัวจัดการตั้งค่า
  locator.registerLazySingleton<SettingsLocalDataSource>(() => SettingsLocalDataSourceImpl(locator<SharedPreferencesService>()));
  locator.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(locator<SettingsLocalDataSource>()));
  locator.registerLazySingleton(() => LoadSetting(locator<SettingsRepository>()));
  locator.registerLazySingleton(() => SaveSetting(locator<SettingsRepository>()));
  locator.registerLazySingleton(() => SettingsCubit(
        loadSetting: locator<LoadSetting>(),
        saveSetting: locator<SaveSetting>(),
      ));

  // ตัวจัดการสถานะ
  locator.registerLazySingleton(() => AppStateCubit());

  // ตัวจัดการการ์ดจาก API
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

  // ตัวจัดการเด็ค
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

  // ตัวจัดการ NFC และ Tag
  locator.registerLazySingleton<TagLocalDataSource>(() => TagLocalDataSourceImpl(locator<SharedPreferencesService>()));
  locator.registerLazySingleton<TagRepository>(() => TagRepositoryImpl(locator<TagLocalDataSource>()));
  locator.registerLazySingleton(() => LoadTagsUseCase(locator<TagRepository>()));
  locator.registerLazySingleton(() => SaveTagUseCase(locator<TagRepository>()));
  locator.registerLazySingleton(() => NFCCubit(
        loadTagsUseCase: locator<LoadTagsUseCase>(),
        saveTagUseCase: locator<SaveTagUseCase>(),
      ));
}
