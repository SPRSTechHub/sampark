// ignore_for_file: must_call_super

import 'package:flutter/material.dart';
import 'package:sampark/model/allcustomers.dart';
import 'package:sampark/utils/api.dart';

class Reports extends StatefulWidget {
  const Reports({Key? key}) : super(key: key);

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  List<AllCustomersData>? customer;
  var isLoaded = false;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    customer = await getAllCustomers();
    if (customer != null) {
      if (!mounted) return;
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Visibility(
        visible: isLoaded,
        replacement: const Align(
          alignment: Alignment.topCenter,
          child: LinearProgressIndicator(),
        ),
        child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: customer?.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: const FlutterLogo(),
                  title: Text(customer![index].name,
                      style: const TextStyle(
                        color: Color(0xffa6a5ac),
                      )),
                  trailing: const Icon(Icons.more_vert),
                ),
              );
            }),
      ),
    );
  }
}
