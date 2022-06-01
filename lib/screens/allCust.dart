// ignore_for_file: must_call_super

import 'package:flutter/material.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:getwidget/getwidget.dart';
import 'package:sampark/model/allcustomers.dart';
import 'package:sampark/screens/profileScreen.dart';
import 'package:sampark/utils/api.dart';

class AllCustomers extends StatefulWidget {
  const AllCustomers({Key? key}) : super(key: key);

  @override
  State<AllCustomers> createState() => _AllCustomersState();
}

class _AllCustomersState extends State<AllCustomers> {
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
                shadowColor: Colors.white60,
                color: Colors.white,
                elevation: 8.0,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: GFListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CustProfile(pid: customer![index].name),
                      ),
                    );
                  },
                  avatar: GFAvatar(
                      backgroundImage: NetworkImage(
                          'https://play.liveipl.online/uploads/${customer![index].imgLink}'),
                      shape: GFAvatarShape.standard),
                  titleText: customer![index].name,
                  subTitleText: customer![index].mobile ?? 'XXX',
                  description: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Loan: Rs. ${customer![index].loanAmnt ?? '0.00'}',
                        style: TextStyle(
                          color: Colors.blue[800],
                        ),
                      ),
                      Text(
                        'Emi: Rs. ${customer![index].emiAmnt ?? '0.00'}',
                        style: TextStyle(
                          color: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                  icon: const Icon(
                    LineariconsFree.arrow_right,
                    color: Colors.black26,
                  ),
                  padding: const EdgeInsets.all(2),
                  margin: const EdgeInsets.all(2),
                ),
              );
            }),
      ),
    );
  }
}
