import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
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

  @override
  void initState() {
    super.initState();
    if (widget.page > 2) {
      selectedPage = widget.page;
    } else {
      selectedPage = 1;
    }
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
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: TopAppBar(title: widget.title),
        ),
        body: selectedPage <= 2
            ? _pageOptions[selectedPage]
            : _pageOptions[widget.page],
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
}
