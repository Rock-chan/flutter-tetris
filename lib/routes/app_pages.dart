import 'package:get/get.dart';
import 'package:tetris_tesouro/page/privacy_page.dart';
import 'package:tetris_tesouro/routes/app_routes.dart';

class AppPages {
  static List<GetPage> getPages() {
    return _pages;
  }

  static final _pages = <GetPage>[
    GetPage(
      name: Routes.privacy,
      page: () => const PrivacyPage(privacyLink: ''),
    )
  ];
}
