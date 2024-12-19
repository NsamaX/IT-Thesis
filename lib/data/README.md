# README for data Directory

## ภาพรวม

โฟลเดอร์ data ทำหน้าที่เป็นชั้นที่จัดการข้อมูลของแอปพลิเคชัน ทั้งในส่วนของการดึงข้อมูลจากภายนอก (API) และการจัดเก็บข้อมูลภายใน (Local Storage) โดยแบ่งเป็น 3 ส่วนหลัก: `datasources`, `models`, และ `repositories`

---

## เนื้อหาและแนวคิดโดยละเอียด

### **1. โครงสร้าง “data”**

- **datasources/**
  - แบ่งออกเป็น 2 ส่วน: `local` และ `remote`
  - **local/**
    - จัดการข้อมูลที่เก็บไว้ใน Local Storage เช่น SQLite หรือ Shared Preferences
    - ตัวอย่างไฟล์:
      - **card.dart**: จัดการข้อมูลการ์ดใน SQLite
      - **deck.dart**: จัดการข้อมูลเด็คใน SQLite
      - **settings.dart**: จัดการการตั้งค่าใน Shared Preferences
  - **remote/**
    - จัดการการดึงข้อมูลจาก API ภายนอก
    - ใช้ Factory Pattern เพื่อรองรับการดึงข้อมูลจากหลายเกม เช่น Vanguard
    - ตัวอย่างไฟล์:
      - **game_factory.dart**: ตัวกลางสำหรับสร้าง API ที่เหมาะสมกับเกมแต่ละประเภท

- **models/**
  - เก็บโครงสร้างข้อมูล (Data Models) ที่ใช้ในแอปพลิเคชัน
  - ใช้ `fromJson` และ `toJson` เพื่อแปลงข้อมูลระหว่างรูปแบบ JSON และ Object
  - ตัวอย่างไฟล์:
    - **card.dart**: โครงสร้างข้อมูลการ์ด
    - **deck.dart**: โครงสร้างข้อมูลเด็ค

- **repositories/**
  - ทำหน้าที่เป็นตัวกลางระหว่าง `datasources` และ `domain`
  - รวมข้อมูลจากทั้ง Local และ Remote เพื่อให้ใช้งานได้ในแอป
  - ตัวอย่างไฟล์:
    - **card.dart**: จัดการข้อมูลการ์ดจาก API และ SQLite
    - **deck.dart**: จัดการข้อมูลเด็คจาก Local Storage

---

## การทำงานของ data

1. **datasources/**: จัดการการเข้าถึงข้อมูลทั้งจาก Local และ Remote
2. **models/**: แปลงข้อมูลให้อยู่ในรูปแบบที่เหมาะสมสำหรับการใช้งานในแอป
3. **repositories/**: รวมข้อมูลจากหลายแหล่งและจัดเตรียมข้อมูลสำหรับการใช้งานใน `domain`

---

## วิธีการใช้งาน

1. **Local Data Source:**
   - ใช้สำหรับดึงและบันทึกข้อมูลใน Local Storage
     ```dart
     final localDataSource = CardLocalDataSourceImpl(sqliteService);
     final cards = await localDataSource.fetchCards('vanguard');
     ```

2. **Remote Data Source:**
   - ใช้สำหรับดึงข้อมูลจาก API ภายนอก
     ```dart
     final gameApi = GameFactory.createApi('vanguard');
     final cards = await gameApi.fetchCardsPage(1);
     ```

3. **Repository:**
   - ใช้เพื่อรวมข้อมูลจาก Local และ Remote
     ```dart
     final repository = CardRepositoryImpl(
       gameApi: gameApi,
       cardLocalDataSource: localDataSource,
     );
     final syncedCards = await repository.syncCards('vanguard');
     ```

---

## สรุป

โฟลเดอร์ data มีบทบาทสำคัญในการจัดการข้อมูลของแอป โดยแบ่งความรับผิดชอบอย่างชัดเจนระหว่างการดึงข้อมูล การแปลงข้อมูล และการรวมข้อมูล ทำให้การจัดการข้อมูลมีความเป็นระบบและง่ายต่อการพัฒนาในอนาคต

