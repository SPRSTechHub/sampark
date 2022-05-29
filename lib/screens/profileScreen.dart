import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustProfile extends StatefulWidget {
  final String pid;

  const CustProfile({Key? key, required this.pid}) : super(key: key);

  @override
  State<CustProfile> createState() => _CustProfileState();
}

class _CustProfileState extends State<CustProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(widget.pid),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Back'),
          ),
        ],
      ),
    );
  }
}
