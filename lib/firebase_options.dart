// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCnUI-YhQhQQdkg3Ne1eadrdz4TVgkZ0GE',
    appId: '1:367572737242:web:4b32bff7df07946232d9e3',
    messagingSenderId: '367572737242',
    projectId: 'nurseryapplication-4d408',
    authDomain: 'nurseryapplication-4d408.firebaseapp.com',
    storageBucket: 'nurseryapplication-4d408.appspot.com',
    measurementId: 'G-KJ4B5QWRH4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCLzOn_yd-hWQAyX5kc3QV0NungApy63vE',
    appId: '1:367572737242:android:c6038ef09f24fc3b32d9e3',
    messagingSenderId: '367572737242',
    projectId: 'nurseryapplication-4d408',
    storageBucket: 'nurseryapplication-4d408.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA1rNAno-FUPN-nFaBS69yMKC4B-qotiKQ',
    appId: '1:367572737242:ios:2c0a411e65fa321832d9e3',
    messagingSenderId: '367572737242',
    projectId: 'nurseryapplication-4d408',
    storageBucket: 'nurseryapplication-4d408.appspot.com',
    iosBundleId: 'com.example.nurseryapplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA1rNAno-FUPN-nFaBS69yMKC4B-qotiKQ',
    appId: '1:367572737242:ios:2c0a411e65fa321832d9e3',
    messagingSenderId: '367572737242',
    projectId: 'nurseryapplication-4d408',
    storageBucket: 'nurseryapplication-4d408.appspot.com',
    iosBundleId: 'com.example.nurseryapplication',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCnUI-YhQhQQdkg3Ne1eadrdz4TVgkZ0GE',
    appId: '1:367572737242:web:1e64a82b9bf1559e32d9e3',
    messagingSenderId: '367572737242',
    projectId: 'nurseryapplication-4d408',
    authDomain: 'nurseryapplication-4d408.firebaseapp.com',
    storageBucket: 'nurseryapplication-4d408.appspot.com',
    measurementId: 'G-NGXNG1D3FB',
  );
}