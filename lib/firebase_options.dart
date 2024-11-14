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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAM8BgJMJtQoJLDEdtbP9Ny6FI7dSFi_H0',
    appId: '1:929582467278:web:6f3116bfe4e3e67c58e89f',
    messagingSenderId: '929582467278',
    projectId: 'hormonalcare-92eee',
    authDomain: 'hormonalcare-92eee.firebaseapp.com',
    storageBucket: 'hormonalcare-92eee.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB6pcwZrUkAyA_03qbcIKEhmbfKlTHk9vU',
    appId: '1:929582467278:android:d0b8ebc946f9733758e89f',
    messagingSenderId: '929582467278',
    projectId: 'hormonalcare-92eee',
    storageBucket: 'hormonalcare-92eee.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDyx3b3QHr-zrNfHdWl2DyVVwtRdvo6q2I',
    appId: '1:929582467278:ios:62a574e387c4186458e89f',
    messagingSenderId: '929582467278',
    projectId: 'hormonalcare-92eee',
    storageBucket: 'hormonalcare-92eee.firebasestorage.app',
    iosBundleId: 'pe.edu.upc.trabajoMovilesNinjacode',
  );

}