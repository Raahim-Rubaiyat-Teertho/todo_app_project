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
    apiKey: 'AIzaSyBvgwOtPSCWvixjBgSgYFDftnQd-mxs_Zk',
    appId: '1:436855844696:web:a6e0d4f28cb1ef01dbbf2d',
    messagingSenderId: '436855844696',
    projectId: 'todoenhance-ec17f',
    authDomain: 'todoenhance-ec17f.firebaseapp.com',
    storageBucket: 'todoenhance-ec17f.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAc2RrrgEpyBJCWN5DlxTQnMoNLKz60laM',
    appId: '1:436855844696:android:c29253fd5c6ea142dbbf2d',
    messagingSenderId: '436855844696',
    projectId: 'todoenhance-ec17f',
    storageBucket: 'todoenhance-ec17f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBCS6t5SwVc7qFfkcA8ciM0Ms8p25Tpl9w',
    appId: '1:436855844696:ios:8c69c4d40bc8e770dbbf2d',
    messagingSenderId: '436855844696',
    projectId: 'todoenhance-ec17f',
    storageBucket: 'todoenhance-ec17f.appspot.com',
    iosBundleId: 'com.example.todoAppProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBCS6t5SwVc7qFfkcA8ciM0Ms8p25Tpl9w',
    appId: '1:436855844696:ios:8c69c4d40bc8e770dbbf2d',
    messagingSenderId: '436855844696',
    projectId: 'todoenhance-ec17f',
    storageBucket: 'todoenhance-ec17f.appspot.com',
    iosBundleId: 'com.example.todoAppProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBvgwOtPSCWvixjBgSgYFDftnQd-mxs_Zk',
    appId: '1:436855844696:web:4e25562ee13179acdbbf2d',
    messagingSenderId: '436855844696',
    projectId: 'todoenhance-ec17f',
    authDomain: 'todoenhance-ec17f.firebaseapp.com',
    storageBucket: 'todoenhance-ec17f.appspot.com',
  );
}
