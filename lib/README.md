<h1 align="center">📂 lib 🛠️</h1>

## ภาพรวม

โฟลเดอร์ `lib` เป็นศูนย์กลางสำหรับการพัฒนาแอปพลิเคชัน โดยออกแบบตามหลักการ **Clean Architecture** เพื่อให้แอปพลิเคชันมีโครงสร้างที่ชัดเจน ขยายตัวง่าย ดูแลรักษาสะดวก และรองรับการทำงานที่ยืดหยุ่น หลักการของ **Clean Architecture** เน้นการแยกเลเยอร์ตามหน้าที่เฉพาะ ได้แก่ `assets`, `core`, `data`, `domain` และ `presentation` แต่ละเลเยอร์สื่อสารกันอย่างเป็นระบบและลดการพึ่งพาโดยตรง เพื่อให้เกิดความยืดหยุ่นในการพัฒนา

---

## **หลักการทำงานของ Clean Architecture**

1. **การแยกเลเยอร์อย่างชัดเจน**:
   - **Presentation**: จัดการ UI และประสบการณ์ผู้ใช้งาน
   - **Domain**: บริหารจัดการตรรกะธุรกิจ (Business Logic) และความต้องการหลักของแอป
   - **Data**: ดูแลการเชื่อมต่อกับแหล่งข้อมูล เช่น API และฐานข้อมูล
   - **Core**: ให้บริการเครื่องมือและทรัพยากรที่ใช้ร่วมกันในทุกเลเยอร์
   - **Assets**: จัดการไฟล์คงที่ เช่น รูปภาพและข้อความแปลภาษา

2. **การสื่อสารระหว่างเลเยอร์**:
   - `presentation` เรียกใช้ `domain` ผ่าน use cases
   - `domain` สื่อสารกับ `data` ผ่าน repository interfaces
   - `data` ใช้ข้อมูลจากแหล่งข้อมูลต่าง ๆ และแปลงเป็น entity ใน `domain`
   - `core` และ `assets` สนับสนุนทุกเลเยอร์ด้วยทรัพยากรคงที่และเครื่องมือที่จำเป็น

---

## **โครงสร้างไดเรกทอรีหลัก**

### **1. assets/**
- **บทบาท**: เก็บทรัพยากรคงที่ เช่น การตั้งค่า API, รูปภาพ, และข้อความแปลภาษา

[ดูเพิ่มเติมใน README ของ assets](../assets/README.md)

---

### **2. core/**
- **บทบาท**: สนับสนุนทุกเลเยอร์ด้วย utilities, services, ค่าคงที่, และการตั้งค่าระดับโกลบอล

[ดูเพิ่มเติมใน README ของ core](./core/README.md)

---

### **3. data/**
- **บทบาท**: จัดการข้อมูลจากแหล่งข้อมูลภายนอก (remote) หรือในเครื่อง (local) และแปลงข้อมูลให้อยู่ในรูปแบบที่เหมาะสม
- **การใช้งาน**:
  - ใช้ `datasources/` เพื่อดึงข้อมูล
  - ใช้ `models/` และ `repositories/` เพื่อประมวลผลและจัดเตรียมข้อมูลสำหรับ `domain`

[ดูเพิ่มเติมใน README ของ data](./data/README.md)

---

### **4. domain/**
- **บทบาท**: แกนกลางของตรรกะธุรกิจในแอปพลิเคชัน
- **การใช้งาน**:
  - ใช้ `entities/` เพื่อกำหนดโครงสร้างข้อมูลเชิงนามธรรม
  - ใช้ `usecases/` เพื่อดำเนินการตรรกะธุรกิจ เช่น การจัดการเด็คหรือการ์ด

[ดูเพิ่มเติมใน README ของ domain](./domain/README.md)

---

### **5. presentation/**
- **บทบาท**: ดูแลส่วน UI และการโต้ตอบกับผู้ใช้งาน
- **การใช้งาน**:
  - ใช้ `cubits/` เพื่อจัดการสถานะ
  - ใช้ `pages/` และ `widgets/` เพื่อแสดงผลข้อมูลและส่วนประกอบ UI

[ดูเพิ่มเติมใน README ของ presentation](./presentation/README.md)

---

หากต้องการข้อมูลเพิ่มเติม สามารถตรวจสอบได้จาก README ของแต่ละโฟลเดอร์ย่อยที่ระบุไว้ด้านบน
