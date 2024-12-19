# README for domain Directory

## ภาพรวม

โฟลเดอร์ domain มีหน้าที่จัดการ **business logic** ของแอปพลิเคชัน โดยมีบทบาทเป็นตัวกลางระหว่าง `data` layer และ `presentation` layer เพื่อให้มั่นใจว่าข้อมูลที่ถูกส่งไปยัง UI ได้รับการประมวลผลอย่างถูกต้อง

---

## เนื้อหาและแนวคิดโดยละเอียด

### **1. โครงสร้าง “domain”**

- **entities/**
  - ใช้สำหรับเก็บโครงสร้างข้อมูลที่เป็นตัวแทนของ business objects
  - ตัวอย่างไฟล์:
    - **card.dart**: โครงสร้างข้อมูลการ์ดที่ใช้ใน business logic
    - **deck.dart**: โครงสร้างข้อมูลเด็ค

- **mappers/**
  - ใช้สำหรับแปลงข้อมูลระหว่าง `entities` และ `models` จาก data layer
  - ตัวอย่างไฟล์:
    - **card.dart**: แปลงข้อมูลระหว่าง `CardEntity` และ `CardModel`

- **usecases/**
  - ใช้สำหรับกำหนด business logic หรือการทำงานเฉพาะ เช่น การซิงค์ข้อมูล
  - ตัวอย่างไฟล์:
    - **sync_cards.dart**: กำหนดการซิงค์ข้อมูลการ์ดจาก data layer
    - **deck_manager.dart**: จัดการเด็คของผู้ใช้

---

## การทำงานของ domain

1. **entities/**: ตัวแทนข้อมูลที่ใช้ใน business logic
2. **mappers/**: แปลงข้อมูลระหว่าง layer เพื่อให้ใช้งานร่วมกันได้ง่าย
3. **usecases/**: กำหนดการทำงานเฉพาะที่เกี่ยวข้องกับ business logic

---

## วิธีการใช้งาน

1. **Entities:**
   - ใช้สำหรับจัดการข้อมูลใน business logic
     ```dart
     final cardEntity = CardEntity(
       cardId: '001',
       game: 'vanguard',
       name: 'Blaster Blade',
     );
     ```

2. **Mappers:**
   - ใช้แปลงข้อมูลระหว่าง data layer และ domain layer
     ```dart
     final cardModel = CardModel.fromJson(jsonData);
     final cardEntity = CardMapper.toEntity(cardModel);
     ```

3. **Usecases:**
   - เรียกใช้ business logic
     ```dart
     final useCase = SyncCardsUseCase(cardRepository);
     final cards = await useCase.call('vanguard');
     ```

---

## สรุป

โฟลเดอร์ domain มีหน้าที่เป็นตัวกลางสำหรับ business logic ที่แยกออกจากการจัดการข้อมูลและการแสดงผล ทำให้การพัฒนามีความยืดหยุ่นและเป็นระบบมากขึ้น

