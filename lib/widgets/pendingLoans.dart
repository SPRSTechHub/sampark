import 'package:flutter/material.dart';
import 'package:sampark/model/emipendings.dart';
import 'package:sampark/utils/api.dart';
import '../screens/emiScreen.dart';

class PendingLoans extends StatefulWidget {
  const PendingLoans({Key? key, required this.empcode}) : super(key: key);
  final String empcode;
  @override
  State<PendingLoans> createState() => _PendingLoansState();
}

class _PendingLoansState extends State<PendingLoans> {
  List<Pendingloandata>? emidata;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    getData(widget.empcode);
  }

  getData(String empcode) async {
    emidata = await getPendingLoans(empcode, '17-07-2022');
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
              return loanlistCard(loandatalist: emidata![index]);
            }),
      ),
    );
  }

  Widget loanlistCard({required Pendingloandata loandatalist}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmiProfile(
                  ccode: loandatalist.custCode, loanno: loandatalist.loanNo),
            ),
          );
        });
      },
      child: Container(
        padding: const EdgeInsets.all(6.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ]),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(children: [
                    const Icon(
                      Icons.verified_user_rounded,
                      color: Colors.black87,
                      size: 48,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(loandatalist.name.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(loandatalist.mobile.toString(),
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 247, 181, 181))),
                          ]),
                    )
                  ]),
                ),
                GestureDetector(
                  onTap: () {
                    //
                  },
                  child: AnimatedContainer(
                    height: 35,
                    padding: const EdgeInsets.all(5),
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: (int.parse(
                                    loandatalist.pendingEmiCount.toString()) >
                                15)
                            ? Colors.red
                            : Colors.grey.shade800,
                        border: Border.all(
                          color: (int.parse(
                                      loandatalist.pendingEmiCount.toString()) >
                                  15)
                              ? Colors.red.shade100
                              : Colors.grey.shade300,
                        )),
                    child: Center(
                      child: Text(
                        loandatalist.pendingEmiCount.toString(),
                        style: const TextStyle(color: Colors.amber),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white38),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: () {},
                        child: const Text('More...'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        //style: ,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EmiProfile(
                                  ccode: loandatalist.custCode,
                                  loanno: loandatalist.loanNo),
                            ),
                          );
                        },
                        child: const Text('Show Emi'),
                      ),
                    ],
                  ),
                  Text(
                    'Rs. ${loandatalist.emiAmnt.toString()}/-',
                    style: TextStyle(color: Colors.grey.shade800, fontSize: 12),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
