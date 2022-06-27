import UIKit
import Flutter
import CardScan
import flutter_downloader



@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate , ScanDelegate, SimpleScanDelegate {
    var controller =  FlutterViewController()
    var flutterResult: FlutterResult?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        controller = window?.rootViewController as! FlutterViewController

        let mainChannel = FlutterMethodChannel(name: "com.beepul/scan_scan",
                                               binaryMessenger: controller.binaryMessenger)

        mainChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            self?.flutterResult = result
            if call.method == "open_scan_card" {
                self?.openScanCard()
            }})

        GeneratedPluginRegistrant.register(with: self)
        FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

  private func openScanCard(){
        guard let vc = ScanViewController.createViewController(withDelegate: self) else {
            print("This device is incompatible with CardScan")
            return
        }
        CreditCardUtils.prefixesRegional += ["8", "9","5"]

      self.controller.present(vc, animated: true)
    }


    func userDidCancelSimple(_ scanViewController: SimpleScanViewController) {

    }

    func userDidScanCardSimple(_ scanViewController: SimpleScanViewController, creditCard: CreditCard) {

    }



    @objc func userDidSkip(_ scanViewController: ScanViewController) {
        self.controller.dismiss(animated: true)
    }

    @objc func userDidCancel(_ scanViewController: ScanViewController) {
        self.controller.dismiss(animated: true)
    }

    @objc func userDidScanCard(_ scanViewController: ScanViewController, creditCard: CreditCard) {

        self.controller.dismiss(animated: true)
        let resultMap = [
            "card_number":creditCard.number,
            "expiry_year":creditCard.expiryYear,
            "expiry_month":creditCard.expiryMonth
        ]
        flutterResult!(resultMap)
    }



}

private func registerPlugins(registry: FlutterPluginRegistry) {
    if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
        FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
    }
}
