import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '@export.dart';
import 'package:nfc_project/data/datasources/local/@export.dart';
import 'package:nfc_project/data/datasources/remote/@export.dart';
import 'package:nfc_project/data/repositories/@export.dart';
import 'package:nfc_project/domain/usecases/@export.dart';
import 'package:nfc_project/presentation/cubits/@export.dart';

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
  locator.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(locator<SettingsLocalDataSource>()));

  locator.registerLazySingleton(() => LoadSettingUseCase(locator<SettingsRepository>()));
  locator.registerLazySingleton(() => SaveSettingUseCase(locator<SettingsRepository>()));
  locator.registerLazySingleton(() => SettingsCubit(
        loadSetting: locator<LoadSettingUseCase>(),
        saveSetting: locator<SaveSettingUseCase>(),
      ));

  //-------------------------------- App State -------------------------------//
  locator.registerLazySingleton(() => AppStateCubit());
  locator.registerLazySingleton(() => NFCCubit());
  locator.registerLazySingleton(() => ScanHistoryCubit());

  //----------------------------------- API ----------------------------------//
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
