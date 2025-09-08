// package io.opencrafts.flow_360
//
// import android.content.ComponentName
// import android.content.Context
// import android.content.Intent
// import android.content.ServiceConnection
// import android.os.IBinder
// import android.util.Log
// import com.ciontek.ciontekposservice.ICiontekPosService
// import io.flutter.embedding.android.FlutterActivity
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodChannel
//
// class MainActivity : FlutterActivity() {
//     private val CHANNEL = "io.opencrafts.flow_360/ciontek_printer"
//     private var ciontekService: ICiontekPosService? = null
//
//     private val connection = object : ServiceConnection {
//     // In MainActivity.kt
//         override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
//           Log.d("MainActivity", "Ciontek service connected successfully.")
//           ciontekService = ICiontekPosService.Stub.asInterface(service)
//           // Signal to Flutter that the service is ready
//           MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL)
//               .invokeMethod("onServiceConnected", null)
//         }
//         // override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
//         //     Log.d("MainActivity", "Ciontek service connected successfully.")
//         //     ciontekService = ICiontekPosService.Stub.asInterface(service)
//         // }
//
//         override fun onServiceDisconnected(name: ComponentName?) {
//             Log.d("MainActivity", "Ciontek service disconnected.")
//             ciontekService = null
//         }
//     }
//
//     override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//         super.configureFlutterEngine(flutterEngine)
//
//         // 1. Bind to the Ciontek hardware service.
//         val intent = Intent("com.caja.pos.hardware.pospay.action.PAY_HARDWARE_SERVICE")
//         intent.setPackage("com.caja.pos.hardware")
//         bindService(intent, connection, Context.BIND_AUTO_CREATE)
//
//         // 2. Set up the MethodChannel to handle incoming method calls from Flutter.
//         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
//             .setMethodCallHandler { call, result ->
//                 if (ciontekService == null) {
//                     result.error("SERVICE_NOT_BOUND", "Ciontek hardware service is not yet bound or not found.", null)
//                     return@setMethodCallHandler
//                 }
//
//                 if (call.method == "printReceipt") {
//                     val text = call.argument<String>("text")
//                     if (text != null) {
//                         printReceipt(text, result)
//                     } else {
//                         result.error("INVALID_ARGUMENT", "The 'text' argument is missing or invalid.", null)
//                     }
//                 } else {
//                     result.notImplemented()
//                 }
//             }
//     }
//
//     private fun printReceipt(text: String, result: MethodChannel.Result) {
//         try {
//             // Check printer status using the method from the AIDL file
//             val status = ciontekService?.Lib_PrnCheckStatus()
//             if (status != 0) {
//                 // Map the status code to a human-readable error message
//                 val errorMessage = when (status) {
//                     -1 -> "Printer needs paper."
//                     -2 -> "High temperature."
//                     -3 -> "Low battery voltage."
//                     else -> "Unknown printer error: $status"
//                 }
//                 result.error("PRINT_ERROR", errorMessage, null)
//                 return
//             }
//
//             // Call the correct printing methods from the AIDL interface
//             ciontekService?.Lib_PrnInit()
//             ciontekService?.Lib_PrnStr(text)
//             ciontekService?.Lib_PrnStart()
//
//             result.success(true)
//         } catch (e: Exception) {
//             Log.e("MainActivity", "Printing failed with an exception.", e)
//             result.error("PRINT_EXCEPTION", e.message, null)
//         }
//     }
//
//     override fun onDestroy() {
//         super.onDestroy()
//         unbindService(connection)
//     }
// }
//
package io.opencrafts.flow_360

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.IBinder
import android.util.Log
import com.ciontek.ciontekposservice.ICiontekPosService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "io.opencrafts.flow_360/ciontek_printer"
    private var ciontekService: ICiontekPosService? = null

    private val connection = object : ServiceConnection {
        override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
            Log.d("MainActivity", "Ciontek service connected successfully.")
            ciontekService = ICiontekPosService.Stub.asInterface(service)
        }

        override fun onServiceDisconnected(name: ComponentName?) {
            Log.d("MainActivity", "Ciontek service disconnected.")
            ciontekService = null
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // 1. Bind to the Ciontek hardware service.
        val intent = Intent("com.caja.pos.hardware.pospay.action.PAY_HARDWARE_SERVICE")
        intent.setPackage("com.caja.pos.hardware")
        bindService(intent, connection, Context.BIND_AUTO_CREATE)

        // 2. Set up the MethodChannel to handle incoming method calls from Flutter.
        // Use the `!!` operator to assert non-nullability
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger!!, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (ciontekService == null) {
                    result.error("SERVICE_NOT_BOUND", "Ciontek hardware service is not yet bound or not found.", null)
                    return@setMethodCallHandler
                }

                if (call.method == "printReceipt") {
                    val text = call.argument<String>("text")
                    if (text != null) {
                        printReceipt(text, result)
                    } else {
                        result.error("INVALID_ARGUMENT", "The 'text' argument is missing or invalid.", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun printReceipt(text: String, result: MethodChannel.Result) {
        try {
            val status = ciontekService?.Lib_PrnCheckStatus()
            if (status != 0) {
                val errorMessage = when (status) {
                    -1 -> "Printer needs paper."
                    -2 -> "High temperature."
                    -3 -> "Low battery voltage."
                    else -> "Unknown printer error: $status"
                }
                result.error("PRINT_ERROR", errorMessage, null)
                return
            }

            ciontekService?.Lib_PrnInit()
            ciontekService?.Lib_PrnStr(text)
            ciontekService?.Lib_PrnStart()

            result.success(true)
        } catch (e: Exception) {
            Log.e("MainActivity", "Printing failed with an exception.", e)
            result.error("PRINT_EXCEPTION", e.message, null)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        unbindService(connection)
    }
}
