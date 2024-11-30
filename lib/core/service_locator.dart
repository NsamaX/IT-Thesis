import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/datasources/local/deck.dart';
import '../data/datasources/local/settings.dart';
import '../data/datasources/local/tag.dart';
import '../data/datasources/remote/game_api_factory.dart';
import '../data/repositories/card.dart';
import '../data/repositories/deck.dart';
import '../data/repositories/settings.dart';
import '../data/repositories/tag.dart';
import '../domain/usecases/deck_manager.dart';
import '../domain/usecases/fetch_cards.dart';
import '../domain/usecases/settings.dart';
import '../domain/usecases/tag.dart';
import '../presentation/blocs/NFC.dart';
import '../presentation/blocs/app_state.dart';
import '../presentation/blocs/deck_manager.dart';
import '../presentation/blocs/locale.dart';

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
}
