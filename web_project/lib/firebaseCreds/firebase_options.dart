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
    apiKey: 'AIzaSyDHpJwjBm7uFRNRglBWtBh6Ju4rjGBX0KU',
    appId: '1:822496908436:web:3fcfc740136255612c5081',
    messagingSenderId: '822496908436',
    projectId: 'iot-kahoot-robophone-sum-c655c',
    authDomain: 'iot-kahoot-robophone-sum-c655c.firebaseapp.com',
    databaseURL: 'https://iot-kahoot-robophone-sum-c655c-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'iot-kahoot-robophone-sum-c655c.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDTCiSX62ItnvI5Ac6-kMO4nhwuJYXZQiQ',
    appId: '1:822496908436:android:ce42d445d5f3d2d82c5081',
    messagingSenderId: '822496908436',
    projectId: 'iot-kahoot-robophone-sum-c655c',
    databaseURL: 'https://iot-kahoot-robophone-sum-c655c-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'iot-kahoot-robophone-sum-c655c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBqT1G89f3P0fnp5zvko68MtiMOi3KeIz8',
    appId: '1:822496908436:ios:aaac301fc6cc1bbf2c5081',
    messagingSenderId: '822496908436',
    projectId: 'iot-kahoot-robophone-sum-c655c',
    databaseURL: 'https://iot-kahoot-robophone-sum-c655c-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'iot-kahoot-robophone-sum-c655c.appspot.com',
    iosClientId: '822496908436-jru5otj1si9bn7s510efinuucdchdj18.apps.googleusercontent.com',
    iosBundleId: 'com.example.webProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBqT1G89f3P0fnp5zvko68MtiMOi3KeIz8',
    appId: '1:822496908436:ios:ca009649e7cf35372c5081',
    messagingSenderId: '822496908436',
    projectId: 'iot-kahoot-robophone-sum-c655c',
    databaseURL: 'https://iot-kahoot-robophone-sum-c655c-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'iot-kahoot-robophone-sum-c655c.appspot.com',
    iosClientId: '822496908436-u2u65h3vou5v4m9nv8ufelnl415pkuad.apps.googleusercontent.com',
    iosBundleId: 'com.example.webProject.RunnerTests',
  );
}