import 'package:get/get.dart';
import 'package:tetris_tesouro/entity/privacy_entity.dart';
import 'package:tetris_tesouro/http/data_urls.dart';
import 'package:tetris_tesouro/http/request.dart';

class GlobalController extends GetxController {
  PrivacyEntity? privacyEntity;

  @override
  void onInit() {
    getGlobalConfigToLoad();
    super.onInit();
  }

  Future<void> getGlobalConfigToLoad() async {
    try {
      var response = await TreasureRequest().get(
        DataUrls.dataList,
      );
      privacyEntity = PrivacyEntity.fromJson(response[4]);
    } catch (e, s) {
      privacyEntity = null;
    }
  }
}
