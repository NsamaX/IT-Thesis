import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nfc_project/data/datasources/local/@export.dart';
import 'package:nfc_project/data/datasources/remote/@export.dart';
import 'package:nfc_project/data/repositories/@export.dart';
import 'package:nfc_project/domain/usecases/@export.dart';
import 'package:nfc_project/presentation/cubits/@export.dart';
import '@export.dart';

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

  //---------------------------- Local DataSource ----------------------------//
  locator.registerLazySingleton<CardLocalDataSource>(() => CardLocalDataSourceImpl(locator<SQLiteService>()));
  locator.registerLazySingleton<SettingsLocalDataSource>(() => SettingsLocalDataSourceImpl(locator<SharedPreferencesService>()));

  //----------------------------- Repositories -------------------------------//
  locator.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(locator<SettingsLocalDataSource>()));
  locator.registerFactoryParam<GameApi, String, void>((game, _) {
    return GameFactory.createApi(game);
  });
  locator.registerFactoryParam<CardRepository, String, void>((game, _) {
    final gameApi = locator<GameApi>(param1: game);
    final cardLocalDataSource = locator<CardLocalDataSource>();
    return CardRepositoryImpl(gameApi: gameApi, cardLocalDataSource: cardLocalDataSource);
  });

  //------------------------------- Use Cases --------------------------------//
  locator.registerLazySingleton(() => LoadSettingUseCase(locator<SettingsRepository>()));
  locator.registerLazySingleton(() => SaveSettingUseCase(locator<SettingsRepository>()));
  locator.registerFactoryParam<SyncCardsUseCase, String, void>((game, _) {
    final cardRepository = locator<CardRepository>(param1: game);
    return SyncCardsUseCase(cardRepository);
  });
  locator.registerFactoryParam<FetchCardByIdUseCase, String, void>((game, _) {
    final cardRepository = locator<CardRepository>(param1: game);
    return FetchCardByIdUseCase(cardRepository);
  });

  //-------------------------------- Cubits ----------------------------------//
  locator.registerLazySingleton(() => SettingsCubit(
        loadSetting: locator<LoadSettingUseCase>(),
        saveSetting: locator<SaveSettingUseCase>(),
      ));
  locator.registerLazySingleton(() => AppStateCubit());
  locator.registerLazySingleton(() => NFCCubit());
  locator.registerFactoryParam<ScanCubit, String, void>((game, _) {
    final fetchCardByIdUseCase = locator<FetchCardByIdUseCase>(param1: game);
    return ScanCubit(fetchCardByIdUseCase: fetchCardByIdUseCase);
  });

  //---------------------------------- Decks ---------------------------------//
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
}
