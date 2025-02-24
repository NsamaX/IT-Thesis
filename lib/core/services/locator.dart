import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nfc_project/data/datasources/local/@export.dart';
import 'package:nfc_project/data/datasources/remote/@export.dart';
import 'package:nfc_project/data/repositories/@export.dart';
import 'package:nfc_project/domain/entities/deck.dart';
import 'package:nfc_project/domain/usecases/@export.dart';
import 'package:nfc_project/presentation/cubits/@export.dart';
import '../storage/@export.dart';

final GetIt locator = GetIt.instance;

/*------------------------------------------------------------------------------
 |  ฟังก์ชัน setupLocator
 |
 |  วัตถุประสงค์:
 |      ลงทะเบียน Dependency Injection สำหรับ Database, DataSources,
 |      Repositories, UseCases, และ Cubits โดยใช้ GetIt
 |
 |  ค่าที่คืนกลับ:
 |      - Future<void> เนื่องจากบาง dependency ต้องรอ async (เช่น SharedPreferences)
 *----------------------------------------------------------------------------*/
Future<void> setupLocator() async {
  await _setupDatabase();
  _setupDataSources();
  _setupRepositories();
  _setupUseCases();
  _setupCubits();
  _setupMisc();
}

/*------------------------------------------------------------------------------
 |  ฟังก์ชัน _setupDatabase
 |
 |  วัตถุประสงค์:
 |      ลงทะเบียน Database Service และ SharedPreferences
 *----------------------------------------------------------------------------*/
Future<void> _setupDatabase() async {
  locator.registerLazySingleton(() => DatabaseService());
  locator.registerLazySingleton(() => SQLiteService(locator<DatabaseService>()));

  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => SharedPreferencesService(sharedPreferences));
}

/*------------------------------------------------------------------------------
 |  ฟังก์ชัน _setupDataSources
 |
 |  วัตถุประสงค์:
 |      ลงทะเบียน Data Sources ทั้งหมด (Local และ Remote)
 *----------------------------------------------------------------------------*/
void _setupDataSources() {
  locator.registerLazySingleton<CardLocalDataSource>(
    () => CardLocalDataSourceImpl(locator<SQLiteService>())
  );
  locator.registerLazySingleton<CollectionLocalDataSource>(
    () => CollectionLocalDataSourceImpl(locator<SQLiteService>())
  );
  locator.registerLazySingleton<DeckLocalDataSource>(
    () => DeckLocalDataSourceImpl(locator<SQLiteService>())
  );
  locator.registerLazySingleton<RecordLocalDataSource>(
    () => RecordLocalDataSourceImpl(locator<SQLiteService>())
  );
  locator.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(locator<SharedPreferencesService>())
  );
}

/*------------------------------------------------------------------------------
 |  ฟังก์ชัน _setupRepositories
 |
 |  วัตถุประสงค์:
 |      ลงทะเบียน Repository สำหรับแต่ละ Data Source
 *----------------------------------------------------------------------------*/
void _setupRepositories() {
  locator.registerFactoryParam<GameApi, String, void>(
    (game, _) => GameFactory.createApi(game)
  );
  locator.registerFactoryParam<CardRepository, String, void>(
    (game, _) => CardRepositoryImpl(
      cardDatasource: locator<CardLocalDataSource>(),
      collectionDatasource: locator<CollectionLocalDataSource>(),
      gameApi: locator<GameApi>(param1: game),
    )
  );
  locator.registerLazySingleton<CollectionRepository>(
    () => CollectionRepositoryImpl(locator<CollectionLocalDataSource>())
  );
  locator.registerLazySingleton<DeckRepository>(
    () => DeckRepositoryImpl(locator<DeckLocalDataSource>())
  );
  locator.registerLazySingleton<RecordRepository>(
    () => RecordRepositoryImpl(locator<RecordLocalDataSource>())
  );
  locator.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(locator<SettingsLocalDataSource>())
  );
}

/*------------------------------------------------------------------------------
 |  ฟังก์ชัน _setupUseCases
 |
 |  วัตถุประสงค์:
 |      ลงทะเบียน UseCases สำหรับการจัดการข้อมูล
 *----------------------------------------------------------------------------*/
void _setupUseCases() {
  locator.registerFactoryParam<FetchCardByIdUseCase, String, void>(
    (game, _) => FetchCardByIdUseCase(locator<CardRepository>(param1: game))
  );
  locator.registerFactoryParam<SyncCardsUseCase, String, void>(
    (game, _) => SyncCardsUseCase(locator<CardRepository>(param1: game))
  );

  locator.registerLazySingleton(() => AddCardToCollectionUseCase(locator<CollectionRepository>()));
  locator.registerLazySingleton(() => RemoveCardFromCollectionUseCase(locator<CollectionRepository>()));
  locator.registerLazySingleton(() => FetchCollectionUseCase(locator<CollectionRepository>()));

  locator.registerLazySingleton(() => AddCardUseCase());
  locator.registerLazySingleton(() => RemoveCardUseCase());
  locator.registerLazySingleton(() => SaveDeckUseCase(locator<DeckRepository>()));
  locator.registerLazySingleton(() => DeleteDeckUseCase(locator<DeckRepository>()));
  locator.registerLazySingleton(() => LoadDecksUseCase(locator<DeckRepository>()));

  locator.registerLazySingleton(() => SaveRecordUseCase(locator<RecordRepository>()));
  locator.registerLazySingleton(() => RemoveRecordUseCase(locator<RecordRepository>()));
  locator.registerLazySingleton(() => FetchRecordUseCase(locator<RecordRepository>()));

  locator.registerLazySingleton(() => SaveSettingUseCase(locator<SettingsRepository>()));
  locator.registerLazySingleton(() => LoadSettingUseCase(locator<SettingsRepository>()));
}

/*------------------------------------------------------------------------------
 |  ฟังก์ชัน _setupCubits
 |
 |  วัตถุประสงค์:
 |      ลงทะเบียน Cubits สำหรับใช้ใน UI
 *----------------------------------------------------------------------------*/
void _setupCubits() {
  locator.registerLazySingleton(() => NFCCubit());

  locator.registerFactoryParam<ScanCubit, String, void>(
    (game, _) => ScanCubit(fetchCardByIdUseCase: locator<FetchCardByIdUseCase>(param1: game))
  );

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

  locator.registerFactoryParam<TrackCubit, DeckEntity, void>(
    (deck, _) => TrackCubit(
      deck,
      saveRecordUseCase: locator<SaveRecordUseCase>(),
      recordUseCase: locator<RemoveRecordUseCase>(),
      fetchRecordUseCase: locator<FetchRecordUseCase>(),
    )
  );

  locator.registerLazySingleton(() => SettingsCubit(
    saveSettingUsecase: locator<SaveSettingUseCase>(),
    loadSettingUsecase: locator<LoadSettingUseCase>(),
  ));

  locator.registerLazySingleton(() => AppCubit());
}

/*------------------------------------------------------------------------------
 |  ฟังก์ชัน _setupMisc
 |
 |  วัตถุประสงค์:
 |      ลงทะเบียน Dependency ที่ไม่ได้อยู่ในกลุ่มหลัก เช่น RouteObserver
 *----------------------------------------------------------------------------*/
void _setupMisc() {
  locator.registerLazySingleton<RouteObserver<ModalRoute>>(
    () => RouteObserver<ModalRoute>()
  );
}
