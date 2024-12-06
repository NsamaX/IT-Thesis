import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nfc_project/data/datasources/@export.dart';
import 'package:nfc_project/data/repositories/@export.dart';
import 'package:nfc_project/domain/usecases/@export.dart';
import 'package:nfc_project/presentation/blocs/@export.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  // AppStateCubit
  locator.registerLazySingleton(() => AppStateCubit());

  // Settings
  locator.registerLazySingleton<SettingsLocalDataSource>(() => SettingsLocalDataSourceImpl(sharedPreferences));
  locator.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(locator<SettingsLocalDataSource>()));

  locator.registerLazySingleton(() => SaveSetting(locator<SettingsRepository>()));
  locator.registerLazySingleton(() => LoadSetting(locator<SettingsRepository>()));

  locator.registerLazySingleton(() => LocaleCubit(
    saveSetting: locator<SaveSetting>(),
    loadSetting: locator<LoadSetting>(),
  ));

  // Deck manager
  locator.registerLazySingleton<DeckLocalDataSource>(() => DeckLocalDataSourceImpl());
  locator.registerLazySingleton<DeckRepository>(() => DeckRepositoryImpl(locator<DeckLocalDataSource>()));

  locator.registerLazySingleton(() => AddCardUseCase());
  locator.registerLazySingleton(() => RemoveCardUseCase());
  locator.registerLazySingleton(() => SaveDeckUseCase(locator<DeckRepository>()));
  locator.registerLazySingleton(() => DeleteDeckUseCase(locator<DeckRepository>()));
  locator.registerLazySingleton(() => LoadDecksUseCase(locator<DeckRepository>()));

  locator.registerFactory(() => DeckManagerCubit(
      addCardUseCase: locator<AddCardUseCase>(),
      removeCardUseCase: locator<RemoveCardUseCase>(),
      saveDeckUseCase: locator<SaveDeckUseCase>(),
      deleteDeckUseCase: locator<DeleteDeckUseCase>(),
      loadDecksUseCase: locator<LoadDecksUseCase>(),
  ));

  // Tag
  locator.registerLazySingleton<TagLocalDataSource>(() => TagLocalDataSourceImpl(sharedPreferences));
  locator.registerLazySingleton<TagRepository>(() => TagRepositoryImpl(locator<TagLocalDataSource>()));

  locator.registerLazySingleton(() => SaveTagUseCase(locator<TagRepository>()));
  locator.registerLazySingleton(() => LoadTagsUseCase(locator<TagRepository>()));

  locator.registerLazySingleton(() => NFCCubit(
    saveTagUseCase: locator<SaveTagUseCase>(),
    loadTagsUseCase: locator<LoadTagsUseCase>(),
  ));
  
  // Card API
  locator.registerFactoryParam<GameApi, String, void>((game, _) {
    return GameApiFactory.createApi(game);
  });

  locator.registerFactoryParam<CardRepository, String, void>((game, _) {
    final gameApi = locator<GameApi>(param1: game);
    return CardRepositoryImpl(gameApi);
  });

  locator.registerFactoryParam<FetchCardsPageUseCase, String, void>((game, _) {
    final cardRepository = locator<CardRepository>(param1: game);
    return FetchCardsPageUseCase(cardRepository);
  });
}
