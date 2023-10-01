import Flutter
import UIKit

public class SwiftCoderjavaImageEditorProPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "coderjava_image_editor_pro", binaryMessenger: registrar.messenger())
    let instance = SwiftCoderjavaImageEditorProPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
