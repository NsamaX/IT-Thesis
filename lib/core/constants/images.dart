import 'dart:collection';

class AppImages {
  static const String _basePath = 'assets/images';

  static final Map<String, String> game = UnmodifiableMapView({
    'vanguard': '$_basePath/vanguard.png',
  });
}
