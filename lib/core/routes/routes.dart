import 'package:flutter/material.dart';
import 'package:nfc_project/presentation/pages/@export.dart';

class AppRoutes {
  /*----------------------------------------------------------------------------
   |  ค่าคงที่ของเส้นทางภายในแอป
   |
   |  วัตถุประสงค์:
   |      กำหนดค่าคงที่สำหรับการนำทาง (Navigation) ไปยังหน้าต่าง ๆ ภายในแอป
   *--------------------------------------------------------------------------*/
  static const String index    = '/';
  static const String signIn   = '/sign_in';
  static const String myDecks  = '/my_decks';
  static const String newDeck  = '/new_deck';
  static const String tracker  = '/tracker';
  static const String read     = '/read';
  static const String games    = '/games';
  static const String search   = '/search';
  static const String card     = '/card';
  static const String setting  = '/setting';
  static const String library  = '/library';
  static const String about    = '/about';
  static const String privacy  = '/privacy';
  static const String language = '/language';

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน generateRoute
   |
   |  วัตถุประสงค์:
   |      กำหนดเส้นทาง (Routes) และคืนค่าเป็น MaterialPageRoute
   |
   |  พารามิเตอร์:
   |      settings (IN) -- ค่า RouteSettings ที่บรรจุชื่อเส้นทางและ arguments
   |
   |  ค่าที่คืนกลับ:
   |      - คืนค่าเป็น Route<dynamic> ที่กำหนดเส้นทางไปยังหน้าที่ตรงกับชื่อ route
   |      - หากไม่พบเส้นทางที่ต้องการ จะแสดงหน้าข้อความแจ้งเตือน
   *--------------------------------------------------------------------------*/
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case index:    page = IndexPage();    break;
      case signIn:   page = SignInPage();   break;
      case myDecks:  page = MyDecksPage();  break;
      case newDeck:  page = NewDeckPage();  break;
      case tracker:  page = TrackerPage();  break;
      case read:     page = ReadPage();     break;
      case games:    page = GamePage();     break;
      case search:   page = SearchPage();   break;
      case card:     page = CardPage();     break;
      case setting:  page = SettingsPage(); break;
      case library:  page = LibraryPage();  break;
      case about:    page = AboutPage();    break;
      case privacy:  page = PrivacyPage();  break;
      case language: page = LanguagePage(); break;
      default:       page = _defaultRoute(settings.name);
    }
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }

  /*----------------------------------------------------------------------------
   |  ฟังก์ชัน _defaultRoute
   |
   |  วัตถุประสงค์:
   |      คืนค่าเป็นหน้าข้อความแจ้งเตือนหากเส้นทางไม่ถูกต้อง
   |
   |  พารามิเตอร์:
   |      routeName (IN) -- ชื่อเส้นทางที่ไม่พบในระบบ
   |
   |  ค่าที่คืนกลับ:
   |      - คืนค่าเป็น Widget ที่แสดงข้อความแจ้งเตือนเส้นทางไม่ถูกต้อง
   *--------------------------------------------------------------------------*/
  static Widget _defaultRoute(String? routeName) => Scaffold(
    body: Center(child: Text('No route defined for $routeName')),
  );
}
