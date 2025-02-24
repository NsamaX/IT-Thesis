import 'package:nfc_project/data/repositories/deck.dart';
import '../entities/card.dart';
import '../entities/deck.dart';
import '../mappers/deck.dart';

/*------------------------------------------------------------------------------
 |  คลาส AddCardUseCase
 |
 |  วัตถุประสงค์:
 |      เพิ่มการ์ดเข้าไปใน Deck และอัปเดตจำนวนการ์ด
 |
 |  พารามิเตอร์:
 |      deck (IN) -- Object `DeckEntity` ที่ต้องการเพิ่มการ์ด
 |      card (IN) -- Object `CardEntity` ที่ต้องการเพิ่มเข้า Deck
 |      count (IN) -- จำนวนการ์ดที่ต้องการเพิ่ม
 |
 |  ค่าที่คืนกลับ:
 |      - คืนค่าเป็น `DeckEntity` ที่มีการ์ดถูกเพิ่มแล้ว
 *----------------------------------------------------------------------------*/
class AddCardUseCase {
  DeckEntity call(DeckEntity deck, CardEntity card, int count) {
    final updatedCards = Map<CardEntity, int>.from(deck.cards);
    updatedCards[card] = (updatedCards[card] ?? 0) + count;
    return deck.copyWith(cards: updatedCards);
  }
}

/*------------------------------------------------------------------------------
 |  คลาส RemoveCardUseCase
 |
 |  วัตถุประสงค์:
 |      ลบการ์ดออกจาก Deck และอัปเดตจำนวนการ์ด
 |
 |  พารามิเตอร์:
 |      deck (IN) -- Object `DeckEntity` ที่ต้องการลบการ์ด
 |      card (IN) -- Object `CardEntity` ที่ต้องการลบออกจาก Deck
 |
 |  ค่าที่คืนกลับ:
 |      - คืนค่าเป็น `DeckEntity` ที่มีการ์ดถูกลบแล้ว
 *----------------------------------------------------------------------------*/
class RemoveCardUseCase {
  DeckEntity call(DeckEntity deck, CardEntity card) {
    final updatedCards = Map<CardEntity, int>.from(deck.cards);
    if (updatedCards.containsKey(card)) {
      updatedCards.update(card, (count) => count - 1, ifAbsent: () => 0);
      if (updatedCards[card]! <= 0) {
        updatedCards.remove(card);
      }
    }
    return deck.copyWith(cards: updatedCards);
  }
}

/*------------------------------------------------------------------------------
 |  คลาส SaveDeckUseCase
 |
 |  วัตถุประสงค์:
 |      บันทึกข้อมูล Deck ลงใน Repository
 |
 |  พารามิเตอร์:
 |      repository (IN) -- Instance ของ DeckRepository ที่ใช้ในการบันทึกข้อมูล
 *----------------------------------------------------------------------------*/
class SaveDeckUseCase {
  final DeckRepository repository;

  SaveDeckUseCase(this.repository);

  Future<void> call(DeckEntity deck) async => repository.saveDeck(DeckMapper.toModel(deck));
}

/*------------------------------------------------------------------------------
 |  คลาส DeleteDeckUseCase
 |
 |  วัตถุประสงค์:
 |      ลบ Deck ออกจาก Repository ตาม deckId ที่ระบุ
 |
 |  พารามิเตอร์:
 |      repository (IN) -- Instance ของ DeckRepository ที่ใช้ในการลบข้อมูล
 *----------------------------------------------------------------------------*/
class DeleteDeckUseCase {
  final DeckRepository repository;

  DeleteDeckUseCase(this.repository);

  Future<void> call(String deckId) async => repository.deleteDeck(deckId);
}

/*------------------------------------------------------------------------------
 |  คลาส LoadDecksUseCase
 |
 |  วัตถุประสงค์:
 |      โหลดข้อมูล Deck ทั้งหมดจาก Repository
 |
 |  พารามิเตอร์:
 |      repository (IN) -- Instance ของ DeckRepository ที่ใช้ในการดึงข้อมูล
 |
 |  ค่าที่คืนกลับ:
 |      - คืนค่าเป็น `List<DeckEntity>` ที่โหลดจาก Repository
 *----------------------------------------------------------------------------*/
class LoadDecksUseCase {
  final DeckRepository repository;

  LoadDecksUseCase(this.repository);

  Future<List<DeckEntity>> call() async {
    final decksModel = await repository.loadDecks();
    return decksModel.map(DeckMapper.toEntity).toList();
  }
}
