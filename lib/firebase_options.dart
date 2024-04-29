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
        return macos;
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
    apiKey: 'AIzaSyANNElVEgszYFVXe_tMv0kRtybXAXah2EI',
    appId: '1:794515890451:web:f94b0465d92f8bd7e6fae6',
    messagingSenderId: '794515890451',
    projectId: 'april-th',
    authDomain: 'april-th.firebaseapp.com',
    storageBucket: 'april-th.appspot.com',
    measurementId: 'G-FNBKBZ1C5B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD8HObKio4yQFDI1_Rifsdo2Gs2Q_nM2u4',
    appId: '1:794515890451:android:6e552a05e001910be6fae6',
    messagingSenderId: '794515890451',
    projectId: 'april-th',
    storageBucket: 'april-th.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBZYtarkf8IZI1FRQq6NFUnMuT2UITkd1E',
    appId: '1:794515890451:ios:1000539c62509dbde6fae6',
    messagingSenderId: '794515890451',
    projectId: 'april-th',
    storageBucket: 'april-th.appspot.com',
    iosClientId: '794515890451-ait7bi1t4j1ii738qku8u1h5gl22kotg.apps.googleusercontent.com',
    iosBundleId: 'com.israfil.april',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBZYtarkf8IZI1FRQq6NFUnMuT2UITkd1E',
    appId: '1:794515890451:ios:2194775ff22d6522e6fae6',
    messagingSenderId: '794515890451',
    projectId: 'april-th',
    storageBucket: 'april-th.appspot.com',
    iosClientId: '794515890451-9uiopadmitc48kgp8glhq26uci6h403k.apps.googleusercontent.com',
    iosBundleId: 'com.israfil.april.RunnerTests',
  );
}
