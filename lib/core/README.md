<h1 align="center">📂 Core 📦</h1>

## ภาพรวม

`core/` เป็นศูนย์รวมของฟังก์ชันหลักที่ช่วยในการทำงานของแอปพลิเคชัน โดยมีบทบาทสำคัญดังนี้:
- จัดเก็บค่าคงที่และการตั้งค่าเริ่มต้น
- จัดการฐานข้อมูลและการเก็บข้อมูลภายในเครื่อง
- ดูแลการนำทางและธีม UI
- จัดการเซสชันและฟังก์ชันเสริม เช่น NFC

---

## โครงสร้างไฟล์ (File Structure)

```plaintext
core/
├── constants/
│   ├── api_config.dart          # การตั้งค่า API
│   ├── images.dart              # การอ้างอิงไฟล์รูปภาพ
├── locales/
│   ├── localizations.dart       # การจัดการการแปลข้อความ
├── routes/
│   ├── routes.dart              # การกำหนดเส้นทางนำทางในแอป
├── services/
│   ├── database.dart            # การจัดการ SQLite
│   ├── locator.dart             # ตัวจัดการ dependency injection
│   ├── shared_preferences.dart  # การจัดเก็บข้อมูลแบบชั่วคราว
│   ├── sqlite.dart              # การทำงานกับ SQLite
├── themes/
│   ├── app_theme.dart           # ธีม UI หลักของแอป
├── utils/
│   ├── nfc_helper.dart          # ตัวช่วยจัดการการใช้งาน NFC
│   ├── nfc_session_handler.dart # การจัดการเซสชัน NFC
```

---

## รายละเอียดโฟลเดอร์

### **1. constants/**
- **วัตถุประสงค์**: เก็บค่าคงที่ที่ใช้ทั่วทั้งแอป
- **ไฟล์สำคัญ**:
  - `api_config.dart`: กำหนดค่าคงที่สำหรับ API เช่น `baseUrl`, `environment`
  - `images.dart`: การอ้างอิงไฟล์รูปภาพ เช่น `assets/images/logo.png`

---

### **2. locales/**
- **วัตถุประสงค์**: รองรับการแปลข้อความในแอป (Localization)
- **ไฟล์สำคัญ**:
  - `localizations.dart`: โหลดและแปลข้อความตามภาษาของผู้ใช้งาน

---

### **3. routes/**
- **วัตถุประสงค์**: กำหนดเส้นทางการนำทาง (Routing)
- **ไฟล์สำคัญ**:
  - `routes.dart`: รวมเส้นทางทั้งหมด เช่น `/home`, `/settings`

---

### **4. services/**
- **วัตถุประสงค์**: จัดการฟังก์ชันหลัก เช่น ฐานข้อมูลและการเก็บข้อมูล
- **ไฟล์สำคัญ**:
  - `database.dart`: จัดการการเชื่อมต่อและการสร้างฐานข้อมูล SQLite
  - `locator.dart`: ตัวจัดการ dependency injection โดยใช้ GetIt เพื่อลดการผูกมัดระหว่าง object
  - `shared_preferences.dart`: บริการสำหรับเก็บข้อมูลชั่วคราว เช่น token, settings
  - `sqlite.dart`: การทำงานกับ SQLite โดยใช้ abstraction layer

---

### **5. themes/**
- **วัตถุประสงค์**: จัดการธีม UI
- **ไฟล์สำคัญ**:
  - `app_theme.dart`: ธีมหลักของแอป เช่น สีตัวอักษร, พื้นหลัง

---

### **6. utils/**
- **วัตถุประสงค์**: เก็บตัวช่วยเฉพาะด้าน
- **ไฟล์สำคัญ**:
  - `nfc_helper.dart`: จัดการการทำงานของ NFC เช่น เริ่ม/หยุดเซสชัน
  - `nfc_session_handler.dart`: ดูแล NFC lifecycle ตามการเปลี่ยนแปลงสถานะของแอป

---
