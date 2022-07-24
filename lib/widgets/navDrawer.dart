// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sampark/utils/prefs.dart';

import '../screens/login.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key, this.uname}) : super(key: key);
  final String? uname;

  @override
  Widget build(BuildContext context) {
    final drawerHeader = UserAccountsDrawerHeader(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 27, 35, 130),
      ),
      accountName: Text(uname!),
      accountEmail: const Text('ff'),
      currentAccountPicture: const CircleAvatar(
        child: FlutterLogo(size: 42.0),
      ),
    );
    final drawerItems = ListView(
      children: [
        drawerHeader,
        ListTile(
          title: const Text('ss'),
          leading: const Icon(Icons.favorite),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text(uname!),
          leading: const Icon(Icons.comment),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Logout'),
          leading: const Icon(Icons.comment),
          onTap: () {
            logout();
            // Navigator.pop(context);
          },
        ),
      ],
    );
    return Drawer(
        child: Container(
            color: const Color.fromARGB(255, 19, 31, 170), child: drawerItems));
  }
}

Future<void> logout() async {
  await UserSimplePreferences.logMeOut();
  Get.to(const AuthScreen());
}
