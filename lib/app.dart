import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:get/get.dart';
import 'package:sampark/utils/config.dart';
import 'package:sampark/utils/push.dart';
import 'package:sampark/widgets/navDrawer.dart';
import 'package:sampark/widgets/topBar.dart';

import 'screens/allCust.dart';
import 'screens/dashboard.dart';
import 'screens/addLoan.dart';
import 'screens/addnew.dart';
import 'screens/collectEmi.dart';
import 'screens/docVerify.dart';
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
  dynamic version = '';
  String wversion = '1.0.1:1';

  Future<void> getAppVersion() async {
    String v = await PackageInfoApi.getAppVersion();
    if (version != v) {
      showAlertDialog();
    }
  }

  @override
  void initState() {
    getAppVersion();
    super.initState();
    if (widget.page > 2) {
      selectedPage = widget.page;
    } else {
      selectedPage = 1;
    }
    LocalNotificationService.initialize(context);
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
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
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

  final _pageOptions = const [
    AllCustomers(),
    Dashboard(),
    Reports(),
    AddNew(),
    AddLoan(),
    CollectEmi(),
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
      onPressed: () {},
      child: const Text('Start'),
    );
    Widget cancel = ElevatedButton(
      style: style,
      onPressed: () {
        Get.back();
      },
      child: const Text('Start'),
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
          Text(version),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[confirm, cancel],
          ),
        ],
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
