
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
            'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      // case TargetPlatform.iOS:
      //   return ios;
      // case TargetPlatform.macOS:
      //   return macos;
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAHAsf51D0A407EklG1bs-5wA7EbyfNFg0',
    appId: '1:448618578101:ios:3d7b3d90894e689eac3efc',
    messagingSenderId: '448618578101',
    projectId: ' "com.example.firebase"',
    databaseURL: 'https://react-native-firebase-testing.firebaseio.com',
    storageBucket: 'react-native-firebase-testing.appspot.com',
  );

  // static const FirebaseOptions ios = FirebaseOptions(
  //   apiKey: 'AIzaSyAHAsf51D0A407EklG1bs-5wA7EbyfNFg0',
  //   appId: '1:448618578101:ios:3d7b3d90894e689eac3efc',
  //   messagingSenderId: '448618578101',
  //   projectId: 'react-native-firebase-testing',
  //   databaseURL: 'https://react-native-firebase-testing.firebaseio.com',
  //   storageBucket: 'react-native-firebase-testing.appspot.com',
  //   androidClientId:
  //   '448618578101-velutq65ok2dr5ohh0oi1q62irr920ss.apps.googleusercontent.com',
  //   iosClientId:
  //   '448618578101-54jhd806d0tr4vkgode0b4fi8iruvjpn.apps.googleusercontent.com',
  //   iosBundleId:
  //   'io.flutter.plugins.firebase.crashlytics.firebaseCrashlyticsExample',
  // );
  //
  // static const FirebaseOptions macos = FirebaseOptions(
  //   apiKey: 'AIzaSyAHAsf51D0A407EklG1bs-5wA7EbyfNFg0',
  //   appId: '1:448618578101:ios:3d7b3d90894e689eac3efc',
  //   messagingSenderId: '448618578101',
  //   projectId: 'react-native-firebase-testing',
  //   databaseURL: 'https://react-native-firebase-testing.firebaseio.com',
  //   storageBucket: 'react-native-firebase-testing.appspot.com',
  //   androidClientId:
  //   '448618578101-velutq65ok2dr5ohh0oi1q62irr920ss.apps.googleusercontent.com',
  //   iosClientId:
  //   '448618578101-54jhd806d0tr4vkgode0b4fi8iruvjpn.apps.googleusercontent.com',
  //   iosBundleId:
  //   'io.flutter.plugins.firebase.crashlytics.firebaseCrashlyticsExample',
  // );
}