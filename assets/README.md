# README for assets Directory

## ภาพรวม

โฟลเดอร์ `assets` มีหน้าที่ในการเก็บทรัพยากรที่ใช้ในแอปพลิเคชัน เช่น ไฟล์คอนฟิก รูปภาพ และข้อความที่แปลเป็นหลายภาษา (localization)

---

## โครงสร้าง “assets”

### **1. configs/**
- ใช้สำหรับเก็บไฟล์คอนฟิกที่เกี่ยวข้องกับแอปพลิเคชัน เช่น การตั้งค่า API
- ตัวอย่างไฟล์:
  - **api.json**: เก็บข้อมูล URL สำหรับ API ใน environment ต่าง ๆ เช่น development และ production

### **2. images/**
- ใช้สำหรับเก็บไฟล์รูปภาพที่ใช้ในแอป เช่น โลโก้ ไอคอน และกราฟิกอื่น ๆ
- ตัวอย่างไฟล์:
  - **google.png**: ไอคอนสำหรับปุ่ม "Sign in with Google"
  - **vanguard.png**: โลโก้ของเกม Vanguard

### **3. locales/**
- ใช้สำหรับเก็บไฟล์ข้อความที่รองรับการแปลภาษาในแอปพลิเคชัน
- ตัวอย่างไฟล์:
  - **en.json**: ข้อความสำหรับภาษาอังกฤษ
  - **ja.json**: ข้อความสำหรับภาษาญี่ปุ่น

---

## การทำงานของ assets

1. **configs/**: ใช้สำหรับตั้งค่าและกำหนดค่าเริ่มต้นของแอป เช่น URL API และ environment
2. **images/**: ใช้เพื่อเพิ่มความสวยงามให้กับ UI ของแอป เช่น รูปภาพและไอคอน
3. **locales/**: ใช้สำหรับรองรับการแปลภาษาเพื่อให้เหมาะสมกับผู้ใช้งานในหลายภูมิภาค

---

## วิธีการใช้งาน

### **1. configs/**
- โหลดไฟล์คอนฟิกเมื่อเริ่มต้นแอป:
  ```dart
  final String config = await rootBundle.loadString('assets/configs/api.json');
  final Map<String, dynamic> apiConfig = json.decode(config);
  ```

### **2. images/**
- แสดงรูปภาพในแอป:
  ```dart
  Image.asset('assets/images/google.png');
  ```

### **3. locales/**
- โหลดข้อความแปลภาษา:
  ```dart
  final String localeData = await rootBundle.loadString('assets/locales/en.json');
  final Map<String, dynamic> translations = json.decode(localeData);
  ```

---

## สรุป

โฟลเดอร์ `assets` เป็นแหล่งเก็บทรัพยากรสำคัญที่ช่วยเพิ่มความสมบูรณ์ให้กับแอปพลิเคชัน ไม่ว่าจะเป็นการตั้งค่าระบบ รูปภาพประกอบ หรือการแปลภาษา ทำให้แอปสามารถใช้งานได้อย่างราบรื่นและเหมาะสมกับผู้ใช้งานในหลายกลุ่มเป้าหมาย

