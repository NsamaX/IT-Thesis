import 'package:get_it/get_it.dart';
import '../data/datasources/local/deck.dart';
import '../data/datasources/remote/game_api_factory.dart';
import '../data/repositories/card.dart';
import '../data/repositories/deck.dart';
import '../domain/usecases/deck_manager.dart';
import '../domain/usecases/fetch_cards.dart';
import '../presentation/blocs/deck_manager.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
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
    ),
  );

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
