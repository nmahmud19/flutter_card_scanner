package com.example.flutter_card_scanner

import android.content.Intent
import androidx.annotation.NonNull
import com.example.flutter_card_scanner.ui.cardscan.ScanActivity
import com.getbouncer.cardscan.base.BuildConfig
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val scanChannel = "com.beepul/scan_scan"
    private var flutterResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            scanChannel
        ).setMethodCallHandler { call, result ->
            if (call.method == "open_scan_card") {
                flutterResult = result
                startScanActivity()
            }
        }
    }

    private fun startScanActivity() {
        ScanActivity.apiKey = BuildConfig.SCANNER_API_KEY
        ScanActivity.start(this, false)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (ScanActivity.isScanResult(requestCode)) {
            if (resultCode == ScanActivity.RESULT_OK && data != null) {
                val scanResult = ScanActivity.creditCardFromResult(data)
                val resultMap = mutableMapOf<String, String?>()
                resultMap["card_number"] = scanResult?.number
                resultMap["expiry_month"] = scanResult?.expiryMonth
                resultMap["expiry_year"] = scanResult?.expiryYear
                flutterResult?.success(resultMap)
            } else if (resultCode == ScanActivity.RESULT_CANCELED) {
                if (data?.getBooleanExtra(ScanActivity.RESULT_FATAL_ERROR, false) == true) {
                    flutterResult?.error("fatal", "No camera", "")
                } else {
                    flutterResult?.error("cancel", "Scan cancelled", "")
                }
            }
        }
    }
}
