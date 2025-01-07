import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nfc_project/data/datasources/local/@export.dart';
import 'package:nfc_project/data/datasources/remote/@export.dart';
import 'package:nfc_project/data/repositories/@export.dart';
import 'package:nfc_project/domain/usecases/@export.dart';
import 'package:nfc_project/presentation/cubits/@export.dart';
import 'database.dart';
import 'shared_preferences.dart';
import 'sqlite.dart';

/// Dependency Injection handler using GetIt
final GetIt locator = GetIt.instance;

/// Configure Dependency Injection
Future<void> setupLocator() async {
  //-------------------------------- Database --------------------------------//
  locator.registerLazySingleton(() => DatabaseService());
  final databaseService = locator<DatabaseService>();

  final sqliteService = SQLiteService(databaseService);
  locator.registerLazySingleton(() => sqliteService);

  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => SharedPreferencesService(sharedPreferences));

  //------------------------------- DataSource -------------------------------//
  locator.registerLazySingleton<CardLocalDataSource>(() => CardLocalDataSourceImpl(locator<SQLiteService>()));
  locator.registerLazySingleton<DeckLocalDataSource>(() => DeckLocalDataSourceImpl(locator<SQLiteService>()));
  locator.registerLazySingleton<SettingsLocalDataSource>(() => SettingsLocalDataSourceImpl(locator<SharedPreferencesService>()));

  //------------------------------ Repositories ------------------------------//
  locator.registerFactoryParam<GameApi, String, void>((game, _) {
    return GameFactory.createApi(game);
  });
  locator.registerFactoryParam<CardRepository, String, void>((game, _) {
    final gameApi = locator<GameApi>(param1: game);
    final cardLocalDataSource = locator<CardLocalDataSource>();
    return CardRepositoryImpl(gameApi: gameApi, cardLocalDataSource: cardLocalDataSource);
  });
  locator.registerLazySingleton<DeckRepository>(() => DeckRepositoryImpl(locator<DeckLocalDataSource>()));
  locator.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(locator<SettingsLocalDataSource>()));

  //-------------------------------- UseCases --------------------------------//
  locator.registerFactoryParam<FetchCardByIdUseCase, String, void>((game, _) {
    final cardRepository = locator<CardRepository>(param1: game);
    return FetchCardByIdUseCase(cardRepository);
  });
  locator.registerFactoryParam<SyncCardsUseCase, String, void>((game, _) {
    final cardRepository = locator<CardRepository>(param1: game);
    return SyncCardsUseCase(cardRepository);
  });

  locator.registerLazySingleton(() => AddCardUseCase());
  locator.registerLazySingleton(() => RemoveCardUseCase());
  locator.registerLazySingleton(() => SaveDeckUseCase(locator<DeckRepository>()));
  locator.registerLazySingleton(() => DeleteDeckUseCase(locator<DeckRepository>()));
  locator.registerLazySingleton(() => LoadDecksUseCase(locator<DeckRepository>()));

  locator.registerLazySingleton(() => SaveSettingUseCase(locator<SettingsRepository>()));
  locator.registerLazySingleton(() => LoadSettingUseCase(locator<SettingsRepository>()));

  //-------------------------------- Cubits ----------------------------------//
  locator.registerLazySingleton(() => NFCCubit());
  locator.registerFactoryParam<ScanCubit, String, void>((game, _) {
    final fetchCardByIdUseCase = locator<FetchCardByIdUseCase>(param1: game);
    return ScanCubit(fetchCardByIdUseCase: fetchCardByIdUseCase);
  });
  locator.registerFactory(() => DeckManagerCubit(
        addCardUseCase: locator<AddCardUseCase>(),
        removeCardUseCase: locator<RemoveCardUseCase>(),
        saveDeckUseCase: locator<SaveDeckUseCase>(),
        deleteDeckUseCase: locator<DeleteDeckUseCase>(),
        loadDecksUseCase: locator<LoadDecksUseCase>(),
      ));
  locator.registerLazySingleton(() => AppStateCubit());
  locator.registerLazySingleton(() => SettingsCubit(
        saveSetting: locator<SaveSettingUseCase>(),
        loadSetting: locator<LoadSettingUseCase>(),
      ));
}
