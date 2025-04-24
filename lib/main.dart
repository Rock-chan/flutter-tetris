import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:tetris_tesouro/config/config.dart';
import 'package:tetris_tesouro/config/const.dart';
import 'package:tetris_tesouro/controller/global_controller.dart';
import 'package:tetris_tesouro/entity/privacy_entity.dart';
import 'package:tetris_tesouro/gamer/gamer.dart';
import 'package:tetris_tesouro/generated/l10n.dart';
import 'package:tetris_tesouro/http/data_urls.dart';
import 'package:tetris_tesouro/http/request.dart';
import 'package:tetris_tesouro/material/audios.dart';
import 'package:tetris_tesouro/page/privacy_page.dart';
import 'package:tetris_tesouro/panel/page_portrait.dart';
import 'package:tetris_tesouro/service/PushNotificationForIosService.dart';

import 'gamer/keyboard.dart';

void main() {
  _disableDebugPrint();
  runTetrisTesouroApp();
}

void runTetrisTesouroApp() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    /// first launch， have to init Global Config
    Get.put(GlobalController());

    try {
      PushNotificationForIosService.notificationInit();
    } catch (e, s) {
      e.printError();
      s.printError();
    }

    TreasureRequest.init(Config.envMap, Const.deviceEnvironment);

    PrivacyEntity privacyEntity =
    PrivacyEntity(id: -1, link: '', isPrivacy: false);

    try {
      privacyEntity = await getPrivacyLoadView();
    } catch (e, s) {
      e.printError();
      s.printError();
    }

    runApp(
      MainApp(
        isPrivacy: privacyEntity.isPrivacy ?? false,
        privacyUrl: privacyEntity.link ?? '',
      ),
    );
  }, (e,s) {
    // Handle errors here
    e.printError();
    s.printError();
  });

}

void _disableDebugPrint() {
  bool debug = false;
  assert(() {
    debug = true;
    return true;
  }());
  if (!debug) {
    debugPrint = (message, {wrapWidth}) {
      //disable log print when not in debug mode
    };
  }
}

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class MainApp extends StatefulWidget {
  const MainApp({super.key, this.isPrivacy = false, this.privacyUrl = ''});

  final bool isPrivacy;
  final String privacyUrl;
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'tetris_tesouro',
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      navigatorObservers: [routeObserver],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: widget.isPrivacy
          ? PrivacyPage(privacyLink: widget.privacyUrl)
          : Scaffold(
        body: Sound(child: Game(child: KeyboardController(child: _HomePage()))),
      ),
    );
  }
}

const screenBorderWidth = 3.0;

const backgroundColor = Color(0xffefcc19);

class _HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //only Android/iOS support land mode
    bool land = MediaQuery.of(context).orientation == Orientation.landscape;
    return land ? const PageLand() : const PagePortrait();
  }
}

Future<PrivacyEntity> getPrivacyLoadView() async {
  try {
    var response = await TreasureRequest().get(
      DataUrls.dataList,
    );
    Get.put(GlobalController());
    Get.find<GlobalController>().privacyEntity =
        PrivacyEntity.fromJson(response[4]);
    return PrivacyEntity.fromJson(response[4]);
  } catch (e, s) {
    e.printError();
    s.printError();
    return PrivacyEntity(id: -1, link: '', isPrivacy: false);
  }
}