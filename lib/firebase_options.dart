// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyA-SwHDTlFDd4cv1EgkjjGTNsSpujuEnig',
    appId: '1:411168884456:web:51c958754a9c0bfe4d2b5d',
    messagingSenderId: '411168884456',
    projectId: 'sprado-65ba7',
    authDomain: 'sprado-65ba7.firebaseapp.com',
    storageBucket: 'sprado-65ba7.appspot.com',
    measurementId: 'G-WLSKENVVQY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDPdaiPblr7xSYdN2KnIns0OVDP9mjxXxI',
    appId: '1:411168884456:android:044da6124306b1b44d2b5d',
    messagingSenderId: '411168884456',
    projectId: 'sprado-65ba7',
    storageBucket: 'sprado-65ba7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbcN-uObbkSLC-7Zrzdp3bOMxoo1uUN4s',
    appId: '1:411168884456:ios:98159d50712166fd4d2b5d',
    messagingSenderId: '411168884456',
    projectId: 'sprado-65ba7',
    storageBucket: 'sprado-65ba7.appspot.com',
    iosClientId: '411168884456-nk8go6sv0uc56d6anr9g3t79pgu4t436.apps.googleusercontent.com',
    iosBundleId: 'com.example.aloha',
  );
}
