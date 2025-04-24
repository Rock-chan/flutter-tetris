import Flutter
import UIKit
import AdjustSdk
import AdSupport
import AppTrackingTransparency
import FBSDKCoreKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let appToken = "2mlv925h0tq8"
    let environment = ADJEnvironmentProduction

    let adjustConfig = ADJConfig(appToken: appToken, environment:environment)
    Adjust.initSdk(adjustConfig)

    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let adjustChannel = FlutterMethodChannel(name: "adjust_plugin", binaryMessenger: controller.binaryMessenger)
    adjustChannel.setMethodCallHandler { (call, result) in
        switch call.method {
            case "getAdjustId":
                Task {  // 这里用 Task 处理 async 方法
                    if let adid = await Adjust.adid() {  // Adjust.adid() 可能变成了 async 方法
                        result(adid)  // 直接返回结果
                    } else {
                        result(nil)  // 获取失败，返回 nil
                    }
                }

            case "getIDFA":
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .authorized:
                    Settings.shared.isAdvertiserTrackingEnabled = true
                        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                        result(idfa)
                    case .denied, .notDetermined, .restricted:
                    Settings.shared.isAdvertiserTrackingEnabled = false
                        result(nil)
                    @unknown default:
                        result(nil)
                    }
                }
            } else {
            Settings.shared.isAdvertiserTrackingEnabled = true
                let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                result(idfa)
            }

            case "getIDFV":
                let idfv = UIDevice.current.identifierForVendor?.uuidString
                result(idfv)
            default:
                result(FlutterMethodNotImplemented)
        }
    }


    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
       Adjust.trackSubsessionStart()
  }

  override func applicationWillResignActive(_ application: UIApplication) {
       Adjust.trackSubsessionEnd()
  }

  func requestTrackingPermission() {
      if #available(iOS 14, *) {
          ATTrackingManager.requestTrackingAuthorization { status in
               print("ATT Status: \(status.rawValue)")
          }
      }
  }
}
