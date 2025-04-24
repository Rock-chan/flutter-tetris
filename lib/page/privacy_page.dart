import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:tetris_tesouro/controller/global_controller.dart';
import 'package:tetris_tesouro/plugin/AdjustPlugin.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key, required this.privacyLink});

  /// to privacy page
  final String privacyLink;

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  WebViewController? webController;
  final GlobalController dataController = Get.find<GlobalController>();

  String privacyUrl = '';

  @override
  void initState() {
    if (widget.privacyLink == "") {
      privacyUrl = dataController.privacyEntity?.link ?? '';
    } else {
      privacyUrl = widget.privacyLink;
    }
    initWebController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: WebViewWidget(controller: webController!),
    );
  }

  initWebController() {
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(privacyUrl))
      ..setOnConsoleMessage((JavaScriptConsoleMessage message) {
      })
      ..setNavigationDelegate(NavigationDelegate(onPageFinished: (url) {
        _injectFlutterMethodChannel();
      }))
      ..addJavaScriptChannel(
        "FlutterBridge",
        onMessageReceived: (JavaScriptMessage message) async {
          if (message.message == "getAdjustId") {
            String? adjustId = await AdjustPlugin.getAdjustId();
            webController!.runJavaScript("""
            window.postMessage("$adjustId", "*");
            """);
          }else if(message.message == "getIDFA"){
            String? idfa = await AdjustPlugin.getIDFA();
            webController!.runJavaScript("""
            window.postMessage("$idfa", "*");
            """);

        }else if(message.message == "getIDFV"){
            String? idfv = await AdjustPlugin.getIDFV();
            webController!.runJavaScript("""
            window.postMessage("$idfv", "*");
            """);
          }
        },
      );
  }

  void _injectFlutterMethodChannel() {
    webController!.runJavaScript("""
    window.callNative = function(method){
      window.FlutterBridge.postMessage(method);
    }
    """);
  }
}
