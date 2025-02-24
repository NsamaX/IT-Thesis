import 'dart:collection';

class AppImages {
  static const String _basePath = 'assets/images';

  /*----------------------------------------------------------------------------
   |  ตัวแปร game
   |
   |  วัตถุประสงค์:
   |      เก็บเส้นทางของไฟล์รูปภาพที่เกี่ยวข้องกับเกม โดยใช้คีย์เป็นชื่อเกม
   |
   |  ค่าที่คืนกลับ:
   |      - เป็น Map<String, String> ที่มี key เป็นชื่อเกม และ value เป็น path ของรูป
   |      - ค่าของตัวแปรนี้เป็น immutable (ไม่สามารถเปลี่ยนแปลงได้)
   *--------------------------------------------------------------------------*/
  static final Map<String, String> game = UnmodifiableMapView({
    'vanguard': '$_basePath/vanguard.png',
  });
}
