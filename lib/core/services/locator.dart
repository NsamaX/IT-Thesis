import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nfc_project/data/datasources/local/@export.dart';
import 'package:nfc_project/data/datasources/remote/@export.dart';
import 'package:nfc_project/data/repositories/@export.dart';
import 'package:nfc_project/domain/usecases/@export.dart';
import 'package:nfc_project/presentation/cubits/@export.dart';
import '@export.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  //-------------------------------- Database --------------------------------//
  locator.registerLazySingleton(() => DatabaseService());
  locator.registerLazySingleton(() => SQLiteService(locator<DatabaseService>()));
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => SharedPreferencesService(sharedPreferences));

  //------------------------------- DataSource -------------------------------//
  locator.registerLazySingleton<CardLocalDataSource>(() => CardLocalDataSourceImpl(locator<SQLiteService>()));
  locator.registerLazySingleton<CollectionLocalDataSource>(() => CollectionLocalDataSourceImpl(locator<SQLiteService>()));
  locator.registerLazySingleton<DeckLocalDataSource>(() => DeckLocalDataSourceImpl(locator<SQLiteService>()));
  locator.registerLazySingleton<SettingsLocalDataSource>(() => SettingsLocalDataSourceImpl(locator<SharedPreferencesService>()));

  //------------------------------ Repositories ------------------------------//
  locator.registerFactoryParam<GameApi, String, void>((game, _) => GameFactory.createApi(game));
  locator.registerFactoryParam<CardRepository, String, void>((game, _) => CardRepositoryImpl(
    cardDatasource: locator<CardLocalDataSource>(),
    collectionDatasource: locator<CollectionLocalDataSource>(),
    gameApi: locator<GameApi>(param1: game),
  ));
  locator.registerLazySingleton<CollectionRepository>(() => CollectionRepositoryImpl(locator<CollectionLocalDataSource>()));
  locator.registerLazySingleton<DeckRepository>(() => DeckRepositoryImpl(locator<DeckLocalDataSource>()));
  locator.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(locator<SettingsLocalDataSource>()));

  //-------------------------------- UseCases --------------------------------//
  locator.registerFactoryParam<FetchCardByIdUseCase, String, void>((game, _) => FetchCardByIdUseCase(
    locator<CardRepository>(param1: game)),
  );
  locator.registerFactoryParam<SyncCardsUseCase, String, void>((game, _) => SyncCardsUseCase(
    locator<CardRepository>(param1: game)),
  );

  locator.registerLazySingleton(() => AddCardToCollectionUseCase(locator<CollectionRepository>()));
  locator.registerLazySingleton(() => RemoveCardFromCollectionUseCase(locator<CollectionRepository>()));
  locator.registerLazySingleton(() => FetchCollectionUseCase(locator<CollectionRepository>()));

  locator.registerLazySingleton(() => AddCardUseCase());
  locator.registerLazySingleton(() => RemoveCardUseCase());
  locator.registerLazySingleton(() => SaveDeckUseCase(locator<DeckRepository>()));
  locator.registerLazySingleton(() => DeleteDeckUseCase(locator<DeckRepository>()));
  locator.registerLazySingleton(() => LoadDecksUseCase(locator<DeckRepository>()));

  locator.registerLazySingleton(() => SaveSettingUseCase(locator<SettingsRepository>()));
  locator.registerLazySingleton(() => LoadSettingUseCase(locator<SettingsRepository>()));

  //-------------------------------- Cubits ----------------------------------//
  locator.registerLazySingleton(() => NFCCubit());
  locator.registerFactoryParam<ScanCubit, String, void>((game, _) => ScanCubit(
    fetchCardByIdUseCase: locator<FetchCardByIdUseCase>(param1: game),
  ));

  locator.registerLazySingleton(() => CollectionCubit(
    addCardUseCase: locator<AddCardToCollectionUseCase>(),
    removeCardUseCase: locator<RemoveCardFromCollectionUseCase>(),
    fetchCollectionUseCase: locator<FetchCollectionUseCase>(),
  ));

  locator.registerFactory(() => DeckManagerCubit(
    addCardUseCase: locator<AddCardUseCase>(),
    removeCardUseCase: locator<RemoveCardUseCase>(),
    saveDeckUseCase: locator<SaveDeckUseCase>(),
    deleteDeckUseCase: locator<DeleteDeckUseCase>(),
    loadDecksUseCase: locator<LoadDecksUseCase>(),
  ));

  locator.registerLazySingleton(() => SettingsCubit(
    saveSettingUsecase: locator<SaveSettingUseCase>(),
    loadSettingUsecase: locator<LoadSettingUseCase>(),
  ));

  locator.registerLazySingleton(() => AppCubit());

  //-------------------------------- Navigation ------------------------------//
  locator.registerLazySingleton<RouteObserver<ModalRoute>>(() => RouteObserver<ModalRoute>());
}
