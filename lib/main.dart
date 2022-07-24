import 'dart:ui';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sampark/app.dart';
import 'package:sampark/screens/login.dart';
import 'package:sampark/utils/prefs.dart';
import 'package:sizer/sizer.dart';

Future<void> _backgroundHandler(RemoteMessage message) async {
//print(message.data.toString());
  // print(message.notification!.title);
}

List<String> testDeviceIds = ['A523AC374E75B4FD4F84EFFCEDE57AF1'];

int? logstat;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  RequestConfiguration configuration =
      RequestConfiguration(testDeviceIds: testDeviceIds);
  MobileAds.instance.updateRequestConfiguration(configuration);
  MobileAds.instance.initialize();
  FacebookAudienceNetwork.init(
      testingId: "f71c4e8d-05db-43b3-ad71-7dae52aeb6a7", //optional
      iOSAdvertiserTrackingEnabled: false //default false
      );
  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  await UserSimplePreferences.init();
  logstat = UserSimplePreferences.getLogin();

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
          home: logstat != null
              //? const AuthScreen()
              ? const Home(
                  title: 'Sampark',
                  page: -1,
                )
              : const AuthScreen(),
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
