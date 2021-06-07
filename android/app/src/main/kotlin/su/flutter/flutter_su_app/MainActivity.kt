package su.flutter.flutter_su_app

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

// Изначальная конфигурация файла
// class MainActivity: FlutterActivity() {
//     override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//         GeneratedPluginRegistrant.registerWith(flutterEngine);
//     }
// }

class MainActivity: FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }
}
