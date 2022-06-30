import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hadith/utils/localstorage.dart';

import 'db/instance.dart';
import 'my_app.dart';

Future<void> main() async {

  runZonedGuarded<Future<void>>(() async {

    WidgetsFlutterBinding.ensureInitialized();
    final database = await getDatabase();

    await LocalStorage.initStorage();
    await Firebase.initializeApp();

    MobileAds.instance.initialize();

    FlutterError.onError =
        FirebaseCrashlytics.instance.recordFlutterFatalError;

    runApp(MyApp(
      appDatabase: database,
    ));
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });

}

