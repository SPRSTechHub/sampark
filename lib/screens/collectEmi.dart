import 'package:flutter/material.dart';

class CollectEmi extends StatefulWidget {
  const CollectEmi({Key? key}) : super(key: key);

  @override
  State<CollectEmi> createState() => _CollectEmiState();
}

class _CollectEmiState extends State<CollectEmi> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('emi collection form'));
  }
}
