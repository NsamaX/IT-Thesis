import 'package:nfc_project/data/repositories/card.dart';
import '../entities/card.dart';
import '../mappers/card.dart';

/*------------------------------------------------------------------------------
 |  คลาส FetchCardByIdUseCase
 |
 |  วัตถุประสงค์:
 |      ใช้สำหรับดึงข้อมูล Card จาก Repository โดยระบุ game และ id
 |
 |  พารามิเตอร์:
 |      repository (IN) -- Instance ของ CardRepository ที่ใช้ในการดึงข้อมูล
 *----------------------------------------------------------------------------*/
class FetchCardByIdUseCase {
  final CardRepository repository;

  FetchCardByIdUseCase(this.repository);

  Future<CardEntity> call(String game, String id) async {
    final localCard = await repository.fetchCardById(game, id);
    return CardMapper.toEntity(localCard);
  }
}

/*------------------------------------------------------------------------------
 |  คลาส SyncCardsUseCase
 |
 |  วัตถุประสงค์:
 |      ใช้สำหรับดึงข้อมูลการ์ดทั้งหมดจากแหล่งข้อมูล (เช่น API) และซิงค์ลง Repository
 |
 |  พารามิเตอร์:
 |      repository (IN) -- Instance ของ CardRepository ที่ใช้ในการซิงค์ข้อมูล
 |
 |  ค่าที่คืนกลับ:
 |      - คืนค่าเป็น `List<CardEntity>` ที่ถูกซิงค์จากแหล่งข้อมูล
 *----------------------------------------------------------------------------*/
class SyncCardsUseCase {
  final CardRepository repository;

  SyncCardsUseCase(this.repository);

  Future<List<CardEntity>> call(String game) async {
    final cardModels = await repository.syncCards(game);
    return cardModels.map(CardMapper.toEntity).toList();
  }
}
