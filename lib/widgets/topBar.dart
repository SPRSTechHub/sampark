import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';

class TopAppBar extends StatefulWidget {
  const TopAppBar({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TopAppBar> createState() => _TopAppBarState();
}

class _TopAppBarState extends State<TopAppBar> with TickerProviderStateMixin {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      color: Colors.indigo[900],
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: Padding(
          padding: EdgeInsets.zero,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: const Icon(
                    LineariconsFree.menu,
                    size: 18,
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Center(
                  child: Text(widget.title,
                      style: const TextStyle(
                        fontSize: 22,
                      )),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    // Scaffold.of(context).openDrawer();
                  },
                  child: const Icon(
                    FontAwesome.bell_alt,
                    size: 18,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    // Scaffold.of(context).openDrawer();
                  },
                  child: const Icon(
                    FontAwesome.search,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}