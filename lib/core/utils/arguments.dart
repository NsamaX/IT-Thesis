import 'package:flutter/material.dart';

/*----------------------------------------------------------------------------
 |  ฟังก์ชัน getArguments
 |
 |  วัตถุประสงค์:
 |      ดึงค่า arguments จาก ModalRoute ของหน้าปัจจุบัน
 |
 |  พารามิเตอร์:
 |      context (IN) -- BuildContext ของหน้า
 |
 |  ค่าที่คืนกลับ:
 |      - Map<String, dynamic> ของ arguments ที่รับเข้ามา
 |      - ถ้าไม่มีค่า arguments หรือไม่ใช่ Map<String, dynamic> จะคืนค่าเป็น {}
 *--------------------------------------------------------------------------*/
Map<String, dynamic> getArguments(BuildContext context) {
  final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
  return arguments ?? {};
}
