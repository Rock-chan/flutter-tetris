import 'package:get/get.dart';
import 'package:tetris_tesouro/controller/global_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GlobalController());
  }
}
