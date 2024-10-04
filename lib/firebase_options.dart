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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBISoq1UgrN5wcNYyZU7-88DoDFixg2K3c',
    appId: '1:364250418374:android:1f77f8c0c6215ef0549bc7',
    messagingSenderId: '364250418374',
    projectId: 'my-development-project-2',
    storageBucket: 'my-development-project-2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyASu5aIy_lPqSEH0trsbEK40igkCo2WYUs',
    appId: '1:364250418374:ios:3295e03405ee8faa549bc7',
    messagingSenderId: '364250418374',
    projectId: 'my-development-project-2',
    storageBucket: 'my-development-project-2.appspot.com',
    androidClientId: '364250418374-0k0m87ek4dk2vp5dtj0qrocpdi51k1th.apps.googleusercontent.com',
    iosClientId: '364250418374-4vm8950l9ft7h0iibki4foniher1d7cu.apps.googleusercontent.com',
    iosBundleId: 'com.kronk.kronk',
  );

}