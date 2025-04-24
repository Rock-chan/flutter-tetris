import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AdjustPlugin {
  static const MethodChannel _channel = MethodChannel('adjust_plugin');

  static Future<String?> getAdjustId() async {
    try {
      final String? adjustId =
          await _channel.invokeMethod<String>('getAdjustId');
      return adjustId;
    } catch (e) {
      e.printError();
    }
    return null;
  }

  static Future<String?> getIDFA() async {
    try {
      final String? adjustId =
      await _channel.invokeMethod<String>('getIDFA');
      return adjustId;
    } catch (e) {
      e.printError();
    }
    return null;
  }

  static Future<String?> getIDFV() async {
    try {
      final String? adjustId =
      await _channel.invokeMethod<String>('getIDFV');
      return adjustId;
    } catch (e) {
      e.printError();
    }
    return null;
  }
}
