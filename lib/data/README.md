### 📂 Data 📦

---

## ภาพรวม

`data/` เป็นศูนย์รวมของการจัดการข้อมูลในแอปพลิเคชัน โดยรับผิดชอบในการจัดหาและบันทึกข้อมูลจากแหล่งต่าง ๆ เช่น Local Storage และ Remote API รวมถึงการประมวลผลข้อมูลและโมเดลที่ใช้ในระบบ

- **Local**: จัดการข้อมูลในเครื่อง เช่น SQLite และ Shared Preferences
- **Remote**: เชื่อมต่อกับ API ภายนอกและจัดการข้อมูลผ่านการเรียก HTTP
- **Repositories**: เป็นตัวกลางที่เชื่อมระหว่างชั้น Data Sources (Local และ Remote) และ Business Logic

---

## โครงสร้างไฟล์ (File Structure)

```plaintext
data/
├── datasources/
│   ├── local/
│   │   ├── card.dart               # สำหรับจัดการข้อมูลการ์ด
│   │   ├── deck.dart               # สำหรับจัดการเด็ค
│   │   ├── settings.dart           # สำหรับจัดการการตั้งค่า
│   ├── remote/
│   │   ├── factories/
│   │   │   ├── 3ase_api.dart       # คลาสพื้นฐานสำหรับ API
│   │   │   ├── vanguard.dart       # API สำหรับเกม Vanguard
│   │   ├── game_factory.dart       # Factory สำหรับเลือก Game API
├── models/
├── repositories/
│   ├── card.dart                   # Repository สำหรับจัดการการ์ด
│   ├── deck.dart                   # Repository สำหรับจัดการเด็ค
│   ├── settings.dart               # Repository สำหรับจัดการการตั้งค่า
```

---

## รายละเอียดโฟลเดอร์

### **1. datasources/local/**
- **วัตถุประสงค์**: จัดการข้อมูลภายในเครื่อง (Local Storage) เช่น SQLite, Shared Preferences
- **ไฟล์สำคัญ**:
  - `card.dart`: จัดการข้อมูลการ์ด เช่น บันทึก, ลบ, และดึงข้อมูลการ์ดจาก Local Storage
  - `deck.dart`: จัดการข้อมูลเด็ค เช่น บันทึก, ลบ, และดึงข้อมูลเด็คจาก Local Storage
  - `settings.dart`: จัดการการตั้งค่า เช่น บันทึกและดึงข้อมูลการตั้งค่าใน Local Storage

---

### **2. datasources/remote/**
- **วัตถุประสงค์**: จัดการข้อมูลจาก API ภายนอก (Remote API)
- **โฟลเดอร์สำคัญ**:
  - **factories/**
    - `game_factory.dart`: Factory ที่ช่วยเลือก API ที่เหมาะสมตามเกมที่ต้องการ 
    - `@base_api.dart`: คลาสพื้นฐานที่มีฟังก์ชันทั่วไปสำหรับ API เช่น การส่งคำร้อง HTTP, ตรวจสอบสถานะคำตอบเช่น Vanguard
    - `vanguard.dart`: API ที่กำหนดสำหรับเกม Vanguard

---

### **3. models/**
- **วัตถุประสงค์**: เก็บข้อมูลแบบโมเดลสำหรับการประมวลผลในระบบ

---

### **4. repositories/**
- **วัตถุประสงค์**: เป็นตัวกลางระหว่างชั้น Data Sources (Local และ Remote) กับ Business Logic
- **ไฟล์สำคัญ**:
  - `card.dart`: จัดการข้อมูลการ์ด เช่น การรวมข้อมูลจาก Local และ Remote
  - `deck.dart`: จัดการข้อมูลเด็ค เช่น การบันทึกและลบเด็คผ่าน Local Data Source
  - `settings.dart`: จัดการข้อมูลการตั้งค่า เช่น การอัปเดตและดึงข้อมูลการตั้งค่าใน Local Storage

---
