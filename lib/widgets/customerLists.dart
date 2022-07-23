import 'package:flutter/material.dart';
import 'package:sampark/model/allcustomers.dart';
import 'package:sampark/utils/api.dart';

class CustomerLists extends StatefulWidget {
  const CustomerLists({Key? key}) : super(key: key);

  @override
  State<CustomerLists> createState() => _CustomerListsState();
}

class _CustomerListsState extends State<CustomerLists> {
  List<AllCustomersData>? customer;
  var isLoaded = false;

  @override
  // ignore: must_call_super
  void initState() {
    super.initState();
    getData();
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
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        leading: Container(
                          padding: const EdgeInsets.only(right: 12.0),
                          decoration: const BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      width: 1.0, color: Colors.white24))),
                          child: CircleAvatar(
                            child: Image.asset(
                                'assets/images/error_logo.png'), /* FadeInImage(
                              image: NetworkImage(
                                  'https://sampark.sprs.store/uploads/${customer![index].imgLink}'),
                              placeholder: const AssetImage(
                                  'assets/images/error_logo.png'),
                            ), */
                          ),
                        ),
                        title: Text(
                          customer![index].name,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                        subtitle: Row(
                          children: const <Widget>[
                            Icon(Icons.linear_scale,
                                color: Colors.yellowAccent),
                            Text(" Intermediate",
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right,
                            color: Colors.white, size: 30.0))),
              );
            }),
      ),
    );
  }
}
