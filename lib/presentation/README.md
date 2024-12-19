# README for presentation Directory

## ภาพรวม

โฟลเดอร์ presentation มีหน้าที่ในการจัดการการแสดงผลและการโต้ตอบกับผู้ใช้ โดยเน้นการแยกส่วนของ UI, State Management และการประสานงานกับ business logic ผ่าน `domain` layer

---

## เนื้อหาและแนวคิดโดยละเอียด

### **1. โครงสร้าง “presentation”**

- **blocs/**
  - ใช้จัดการสถานะของ UI โดยใช้ BLoC (Business Logic Component)
  - ตัวอย่างไฟล์:
    - **app_state.dart**: จัดการสถานะของแอป เช่น หน้าปัจจุบันและเกมที่เลือก
    - **deck_manager.dart**: จัดการสถานะและการทำงานที่เกี่ยวข้องกับเด็ค เช่น การเพิ่ม/ลบการ์ด
    - **NFC.dart**: จัดการการอ่าน/เขียนแท็ก NFC

- **pages/**
  - ประกอบด้วยหน้าจอในแอปพลิเคชัน แยกตามหมวดหมู่เพื่อความชัดเจน
  - ตัวอย่างโฟลเดอร์ย่อย:
    - **deck_section/**: รวมหน้าจอที่เกี่ยวข้องกับเด็ค เช่น `my_decks.dart`, `tracker.dart`
    - **read_section/**: รวมหน้าจอสำหรับอ่านแท็ก NFC และค้นหาการ์ด เช่น `games.dart`, `scan.dart`

- **widgets/**
  - รวม UI Components ที่สามารถนำกลับมาใช้ซ้ำได้ เช่น ปุ่ม แถบนำทาง หรือการ์ดแสดงผล
  - ตัวอย่างไฟล์:
    - **navigation_bar.dart**: แถบนำทางที่ใช้ในหลายหน้า
    - **dialog.dart**: แสดงข้อความแจ้งเตือนหรือยืนยันการทำงาน

---

## การทำงานของ presentation

1. **blocs/**: จัดการ State Management เพื่อควบคุมการทำงานของ UI
2. **pages/**: แสดงผลหน้าจอและประสานงานกับ BLoC เพื่ออัปเดต UI
3. **widgets/**: สร้างส่วนประกอบ UI ที่สามารถนำกลับมาใช้ซ้ำได้ในหลายหน้าจอ

---

## วิธีการใช้งาน

1. **BLoC:**
   - จัดการสถานะและการทำงานใน UI
     ```dart
     final deckManagerCubit = DeckManagerCubit(
       addCardUseCase: addCard,
       removeCardUseCase: removeCard,
       loadDecksUseCase: loadDecks,
       saveDeckUseCase: saveDeck,
       deleteDeckUseCase: deleteDeck,
     );
     ```

2. **Pages:**
   - สร้างหน้าจอใหม่และเชื่อมโยงกับ BLoC
     ```dart
     class MyDecksPage extends StatelessWidget {
       @override
       Widget build(BuildContext context) {
         return BlocBuilder<DeckManagerCubit, DeckManagerState>(
           builder: (context, state) {
             return ListView.builder(
               itemCount: state.allDecks.length,
               itemBuilder: (context, index) {
                 final deck = state.allDecks[index];
                 return ListTile(title: Text(deck.deckName));
               },
             );
           },
         );
       }
     }
     ```

3. **Widgets:**
   - สร้างส่วนประกอบ UI ที่สามารถนำกลับมาใช้ได้ในหลายหน้าจอ
     ```dart
     class CustomButton extends StatelessWidget {
       final String label;
       final VoidCallback onPressed;

       const CustomButton({required this.label, required this.onPressed});

       @override
       Widget build(BuildContext context) {
         return ElevatedButton(
           onPressed: onPressed,
           child: Text(label),
         );
       }
     }
     ```

---

## สรุป

โฟลเดอร์ presentation มีบทบาทสำคัญในการจัดการ UI และ State Management โดยแยกหน้าที่ของส่วนประกอบต่าง ๆ อย่างชัดเจน เพื่อให้การพัฒนามีความยืดหยุ่นและสามารถขยายได้ในอนาคต

