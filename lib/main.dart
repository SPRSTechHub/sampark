import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sampark/app.dart';
import 'package:sampark/utils/push.dart';
import 'package:sizer/sizer.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

List<String> testDeviceIds = ['2589CF5FD4D7E0134C7CC050F01300C4'];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  RequestConfiguration configuration =
      RequestConfiguration(testDeviceIds: testDeviceIds);
  MobileAds.instance.updateRequestConfiguration(configuration);

  MobileAds.instance.initialize();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          scrollBehavior: AppScrollBehavior(),
          title: 'Sampark Finance',
          theme: ThemeData(
            useMaterial3: true,
            textTheme: const TextTheme(
                bodyText1: TextStyle(color: Colors.white),
                bodyText2: TextStyle(color: Colors.white),
                headline1: TextStyle(color: Colors.white),
                subtitle2: TextStyle(color: Colors.white)),
          ),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.system,
          home: const Home(
            title: 'Sampark',
            page: -1,
          ),
        );
      },
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
