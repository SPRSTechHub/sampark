import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sampark/model/emipendings.dart';
import 'package:sampark/utils/api.dart';
import 'package:sampark/utils/prefs.dart';
import 'package:sampark/utils/utils.dart';

import 'emipayments.dart';

class PendingEmis extends StatefulWidget {
  const PendingEmis({Key? key, required this.loanno}) : super(key: key);
  final String loanno;

  @override
  State<PendingEmis> createState() => _PendingEmisState();
}

class _PendingEmisState extends State<PendingEmis> {
  List<Pendingloanemi>? emidata;
  String? empcode;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    empcode = UserSimplePreferences.getUsername() ?? '';
    getData();
  }

  getData() async {
    emidata = await getPendingEmi(widget.loanno, empcode!, '17-07-2022');
    if (emidata != null) {
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
            itemCount: emidata?.length,
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
                      borderRadius: BorderRadius.circular(6.0),
                      color: AppColor.emiListTileBG),
                  child: ListTile(
                      onTap: () => (emidata![index].emiCode != null)
                          ? showCupertinoModalBottomSheet(
                              expand: true,
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => EmiPayModal(
                                  emicode: emidata![index].emiCode,
                                  agentcode: empcode,
                                  emiamnt: emidata![index].emiAmount),
                            )
                          : Get.snackbar('Alert', 'Emi Code error!'),
                      title: Text(
                        'Date:${emidata![index].date}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        children: [
                          const SizedBox(
                            height: 4,
                          ),
                          const Text('Click to Pay Emi',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Rs. ${emidata![index].emiAmount} /-',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Emi:${emidata![index].emiCode}',
                                style: const TextStyle(
                                  color: Colors.white60,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right,
                          color: Colors.white, size: 30.0)),
                ),
              );
            }),
      ),
    );
  }
}
