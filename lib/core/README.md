<h1 align="center">📂 Core 📦</h1>

## ภาพรวม

โฟลเดอร์ `core` เป็นศูนย์กลางของโค้ดสำคัญในแอปพลิเคชัน โดยเก็บทุกอย่างที่เกี่ยวข้องกับการตั้งค่าเริ่มต้น การจัดการข้อมูล การนำทาง และการบริการหลัก เพื่อให้การพัฒนาและการบำรุงรักษาเป็นไปได้อย่างมีประสิทธิภาพ

---

## โครงสร้าง “core”

### **1. constants/**
- **วัตถุประสงค์**: เก็บค่าคงที่ที่ใช้ในแอปพลิเคชัน เช่น การตั้งค่า API และรายการรูปภาพ
- **ตัวอย่างไฟล์**:
  - `api_config.dart`: ค่าคงที่สำหรับการตั้งค่า API
  - `images.dart`: การอ้างอิงถึงไฟล์รูปภาพในแอป

### **2. exceptions/**
- **วัตถุประสงค์**: จัดการข้อผิดพลาดหรือสถานการณ์ที่ไม่คาดคิดในแอป
- **ตัวอย่างไฟล์**:
  - `api.dart`: จัดการข้อผิดพลาดที่เกี่ยวกับ API
  - `factory.dart`: จัดการข้อผิดพลาดที่เกี่ยวกับแม่แบบ
  - `local_data.dart`: ข้อผิดพลาดที่เกี่ยวข้องกับข้อมูลภายในเครื่อง

### **3. locales/**
- **วัตถุประสงค์**: จัดการการแปลข้อความในแอปพลิเคชัน

### **4. routes/**
- **วัตถุประสงค์**: กำหนดเส้นทางและการนำทางในแอปพลิเคชัน

### **5. services/**
- **วัตถุประสงค์**: รวมบริการที่เกี่ยวข้องกับฐานข้อมูล การจัดการทรัพยากร และฟังก์ชันสำคัญ
- **ตัวอย่างไฟล์**:
  - `database.dart`: การจัดการฐานข้อมูล SQLite
  - `shared_preferences.dart`: การจัดเก็บข้อมูลชั่วคราว
  - `locator.dart`: ตัวจัดการ dependency injection

### **6. themes/**
- **วัตถุประสงค์**: จัดการธีมและการออกแบบ UI ของแอปพลิเคชัน

### **7. utils/**
- **วัตถุประสงค์**: เก็บยูทิลิตี้หรือเครื่องมือที่ช่วยในงานเฉพาะ
- **ตัวอย่างไฟล์**:
  - `nfc_helper.dart`: ตัวช่วยสำหรับการใช้งาน NFC
  - `nfc_session_handler.dart`: การจัดการเซสชัน NFC

---
