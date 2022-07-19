// ignore_for_file: file_names

import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const drawerHeader = UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 27, 35, 130),
      ),
      accountName: Text('ff'),
      accountEmail: Text('ff'),
      currentAccountPicture: CircleAvatar(
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
          title: const Text('ss'),
          leading: const Icon(Icons.comment),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('ss'),
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
  // await prefs.remove('counter');
}
