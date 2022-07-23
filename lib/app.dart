// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:get/get.dart';
//import 'package:sampark/model/extra.dart';
import 'package:sampark/screens/addDocs.dart';
import 'package:sampark/screens/agenScreen.dart';

import 'package:sampark/utils/config.dart';
import 'package:sampark/utils/api.dart';
import 'package:sampark/utils/prefs.dart';
import 'package:sampark/utils/push.dart';
import 'package:sampark/widgets/navDrawer.dart';
import 'package:sampark/widgets/topBar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'screens/allCust.dart';
import 'screens/addLoan.dart';
import 'screens/addnew.dart';
import 'screens/reports.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title, required this.page})
      : super(key: key);
  final String title;
  final int page;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int selectedPage;
  dynamic vLocal = '';
  dynamic vWeb = '';
  String message = '';
  String updateUri = '';
  String usertype = 'agent';

  Future<void> getAppVersion() async {
    String vLocal = await PackageInfoApi.getAppVersion();
    var acsRsp = await getAccess('notoken');

    if (acsRsp != null) {
      if (acsRsp['data'] != null) {
        vWeb = acsRsp['data']['app_version'];
        updateUri = acsRsp['data']['updateUrl'];
        int v1Number = getExtendedVersionNumber(vLocal);
        int v2Number = getExtendedVersionNumber(vWeb);

        if (v1Number != v2Number) {
          message = 'Pls update your app from ${vLocal} to ${vWeb}';
          showAlertDialog();
        }
      }
    }
  }

  lunchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    getAppVersion();
    if (widget.page > 2) {
      selectedPage = widget.page;
    } else {
      selectedPage = UserSimplePreferences.getLogin() ?? 0;
    }

    LocalNotificationService.initialize(context);
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        // print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          //  print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );
    FirebaseMessaging.onMessage.listen(
      (message) {
        //print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          /*   print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}"); */
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        // print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          //  print(message.notification!.title);
//print(message.notification!.body);
          //   print("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

  final _pageOptions = const [
    AllCustomers(),
    AgentScreen(),
    // Dashboard(),
    Reports(),
    AddNew(),
    AddLoan(),
    DocVrf(ccode: null)
  ];

  @override
  Widget build(BuildContext context) {
    //Future.delayed(Duration.zero, () => showAlert(context));
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: TopAppBar(title: widget.title),
        ),
        body: pageMaker(),
        drawer: const Drawer(
          child: NavDrawer(),
        ),
        bottomNavigationBar: ConvexAppBar.badge(
          const {2: '990+'},
          badgeMargin: const EdgeInsets.only(bottom: 32, left: 40),
          style: TabStyle.reactCircle,
          backgroundColor: Colors.indigo[900],
          color: Colors.white60,
          activeColor: Colors.white,
          items: const [
            TabItem(
                icon: Icon(
                  Typicons.users_outline,
                  color: Colors.black87,
                  size: 18,
                ),
                title: 'Add'),
            TabItem(
                icon: Icon(
                  Typicons.th_large_outline,
                  color: Colors.black87,
                  size: 18,
                ),
                title: 'Dashboard'),
            TabItem(
                icon: Icon(
                  Typicons.news,
                  color: Colors.black87,
                  size: 18,
                ),
                title: 'Reports'),
          ],
          initialActiveIndex: 1,
          onTap: (int index) {
            if (!mounted) {
              return;
            } else {
              if (index > 2) {
                if (!mounted) return;
                setState(() {
                  selectedPage = widget.page;
                });
              } else {
                if (!mounted) return;
                setState(() {
                  selectedPage = index;
                });
              }
            }
          },
        ));
  }

  pageMaker() {
    return Container(
      child: selectedPage <= 2
          ? _pageOptions[selectedPage]
          : _pageOptions[widget.page],
    );
  }

  void showAlertDialog() {
    showAlert(context);
  }

  showAlert(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 12));

    Widget confirm = ElevatedButton(
      style: style,
      onPressed: () {
        lunchUrl(updateUri);
      },
      child: const Text('Update'),
    );
    Widget cancel = ElevatedButton(
      style: style,
      onPressed: () {
        // Get.back();
      },
      child: const Text('Cancel'),
    );

    Get.defaultDialog(
      title: "Update Available!",
      barrierDismissible: false,
      backgroundColor: Colors.indigo[900],
      titleStyle: const TextStyle(color: Colors.white),
      middleTextStyle: const TextStyle(color: Colors.white),
      radius: 8,
      content: Column(
        children: [
          Text(message),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[cancel, confirm],
          ),
        ],
      ),
      onWillPop: () async {
        return false;
      },
    );
  }

  int getExtendedVersionNumber(String version) {
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  }
}
