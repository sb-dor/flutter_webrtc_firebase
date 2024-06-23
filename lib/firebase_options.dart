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
    apiKey: 'AIzaSyDfn_XBBEf8geGm3y97aN5XuYl6LH59Wuk',
    appId: '1:176015174248:web:a173a24194cc6eae1e69dd',
    messagingSenderId: '176015174248',
    projectId: 'yahay-9f28f',
    authDomain: 'yahay-9f28f.firebaseapp.com',
    storageBucket: 'yahay-9f28f.appspot.com',
    measurementId: 'G-YB8BF787NV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDhcnBjEsmPPKkhAyPlX5Qdhhj0GgattM8',
    appId: '1:176015174248:android:45f8ce56cc4d79bd1e69dd',
    messagingSenderId: '176015174248',
    projectId: 'yahay-9f28f',
    storageBucket: 'yahay-9f28f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD5oQYkkpSx5O6PJbag8dMXIkBrV2T2-mA',
    appId: '1:176015174248:ios:91882a0230fa07c41e69dd',
    messagingSenderId: '176015174248',
    projectId: 'yahay-9f28f',
    storageBucket: 'yahay-9f28f.appspot.com',
    androidClientId: '176015174248-4tg320d7enct763d721lt2nv58bbnv5r.apps.googleusercontent.com',
    iosClientId: '176015174248-lusmaha3f835b11ojgjpbpgjjr63u7u1.apps.googleusercontent.com',
    iosBundleId: 'dev.flutterexplained.webrtc',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD5oQYkkpSx5O6PJbag8dMXIkBrV2T2-mA',
    appId: '1:176015174248:ios:05ad958fe5912e7d1e69dd',
    messagingSenderId: '176015174248',
    projectId: 'yahay-9f28f',
    storageBucket: 'yahay-9f28f.appspot.com',
    androidClientId: '176015174248-4tg320d7enct763d721lt2nv58bbnv5r.apps.googleusercontent.com',
    iosClientId: '176015174248-dt8r492e36r188q59ou181enfkooqfnn.apps.googleusercontent.com',
    iosBundleId: 'dev.flutterexplained.webrtcTutorial',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDfn_XBBEf8geGm3y97aN5XuYl6LH59Wuk',
    appId: '1:176015174248:web:97a011e902e23cd71e69dd',
    messagingSenderId: '176015174248',
    projectId: 'yahay-9f28f',
    authDomain: 'yahay-9f28f.firebaseapp.com',
    storageBucket: 'yahay-9f28f.appspot.com',
    measurementId: 'G-5FWLGHNJ7E',
  );
}
