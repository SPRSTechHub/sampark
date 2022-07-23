// ignore_for_file: must_call_super

import 'package:flutter/material.dart';
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 8.0,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: const Color.fromARGB(228, 0, 43, 122)),
                  child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CustProfile(pid: customer![index].name),
                          ),
                        );
                      },
                      leading: customer![index].imgLink != null
                          ? CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage(
                                  'https://sampark.sprs.store/uploads/${customer![index].imgLink}'),
                            )
                          : const CircleAvatar(
                              //  radius: 100,
                              backgroundImage:
                                  AssetImage('assets/images/error_logo.png'),
                            ),
                      // ignore: unnecessary_null_comparison
                      title: Text(
                        customer![index].name,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: customer![index].cstatus == 'Y'
                          ? Column(
                              children: [
                                Text(
                                  textAlign: TextAlign.left,
                                  'M: ${customer![index].mobile ?? 'XXXXX'}',
                                  style: const TextStyle(
                                    color: Colors.white60,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Loan:${customer![index].loanAmnt ?? '0.00'}',
                                      style: const TextStyle(
                                        color: Colors.white60,
                                      ),
                                    ),
                                    Text(
                                      'Emi:${customer![index].emiAmnt ?? '0.00'}',
                                      style: const TextStyle(
                                        color: Colors.white60,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : const Text('No Loan Attached',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600)),
                      trailing: const Icon(Icons.keyboard_arrow_right,
                          color: Colors.white, size: 30.0)),
                ),
              );
            }),
      ),
    );
  }
}
