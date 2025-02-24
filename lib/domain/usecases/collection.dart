import 'package:nfc_project/data/repositories/collection.dart';
import '../entities/card.dart';
import '../mappers/card.dart';

/*------------------------------------------------------------------------------
 |  คลาส AddCardToCollectionUseCase
 |
 |  วัตถุประสงค์:
 |      ใช้สำหรับเพิ่มการ์ดเข้าไปในคอลเลกชันของผู้ใช้
 |
 |  พารามิเตอร์:
 |      repository (IN) -- Instance ของ CollectionRepository ที่ใช้ในการบันทึกข้อมูล
 *----------------------------------------------------------------------------*/
class AddCardToCollectionUseCase {
  final CollectionRepository repository;

  AddCardToCollectionUseCase(this.repository);

  Future<void> call(CardEntity card) async {
    final cardModel = CardMapper.toModel(card);
    await repository.addCardToCollection(cardModel);
  }
}

/*------------------------------------------------------------------------------
 |  คลาส RemoveCardFromCollectionUseCase
 |
 |  วัตถุประสงค์:
 |      ใช้สำหรับลบการ์ดออกจากคอลเลกชันของผู้ใช้
 |
 |  พารามิเตอร์:
 |      repository (IN) -- Instance ของ CollectionRepository ที่ใช้ในการลบข้อมูล
 *----------------------------------------------------------------------------*/
class RemoveCardFromCollectionUseCase {
  final CollectionRepository repository;

  RemoveCardFromCollectionUseCase(this.repository);

  Future<void> call(String cardId) async {
    await repository.removeCardFromCollection(cardId);
  }
}

/*------------------------------------------------------------------------------
 |  คลาส FetchCollectionUseCase
 |
 |  วัตถุประสงค์:
 |      ใช้สำหรับดึงข้อมูลคอลเลกชันการ์ดของผู้ใช้จาก Repository
 |
 |  พารามิเตอร์:
 |      repository (IN) -- Instance ของ CollectionRepository ที่ใช้ในการดึงข้อมูล
 |
 |  ค่าที่คืนกลับ:
 |      - คืนค่าเป็น `List<CardEntity>` ที่โหลดจาก Repository
 *----------------------------------------------------------------------------*/
class FetchCollectionUseCase {
  final CollectionRepository repository;

  FetchCollectionUseCase(this.repository);

  Future<List<CardEntity>> call() async {
    final cardModels = await repository.fetchCollection();
    return cardModels.map(CardMapper.toEntity).toList();
  }
}
