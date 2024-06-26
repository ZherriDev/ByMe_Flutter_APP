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
    apiKey: 'AIzaSyCLykVeSzJsq1Vu8fm5DbBtFAbGX1qCNRM',
    appId: '1:592675043830:web:18df68cc9f014a029cafd7',
    messagingSenderId: '592675043830',
    projectId: 'byme-app-images',
    authDomain: 'byme-app-images.firebaseapp.com',
    databaseURL: 'https://byme-app-images-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'byme-app-images.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDjqMhiznugy6ZNnZ3LdDNiApmfbQdsAzc',
    appId: '1:592675043830:android:6268d11b906ed5589cafd7',
    messagingSenderId: '592675043830',
    projectId: 'byme-app-images',
    databaseURL: 'https://byme-app-images-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'byme-app-images.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAA1q-1wHIsyzgqZblqAR2KXDxwzW1TD4E',
    appId: '1:592675043830:ios:69de34ebb6bd5f889cafd7',
    messagingSenderId: '592675043830',
    projectId: 'byme-app-images',
    databaseURL: 'https://byme-app-images-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'byme-app-images.appspot.com',
    iosBundleId: 'com.example.bymeFlutterApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAA1q-1wHIsyzgqZblqAR2KXDxwzW1TD4E',
    appId: '1:592675043830:ios:69de34ebb6bd5f889cafd7',
    messagingSenderId: '592675043830',
    projectId: 'byme-app-images',
    databaseURL: 'https://byme-app-images-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'byme-app-images.appspot.com',
    iosBundleId: 'com.example.bymeFlutterApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCLykVeSzJsq1Vu8fm5DbBtFAbGX1qCNRM',
    appId: '1:592675043830:web:4dbbbc2132fd3cef9cafd7',
    messagingSenderId: '592675043830',
    projectId: 'byme-app-images',
    authDomain: 'byme-app-images.firebaseapp.com',
    databaseURL: 'https://byme-app-images-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'byme-app-images.appspot.com',
  );

}