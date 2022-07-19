import 'package:flutter/material.dart';

class AddCustImage extends StatefulWidget {
  const AddCustImage({Key? key, required imageKey}) : super(key: key);

  @override
  State<AddCustImage> createState() => _AddCustImageState();
}

class _AddCustImageState extends State<AddCustImage> {
  @override
  Widget build(BuildContext context) {
    return Container(child: const Text('image upload'));
  }
}
