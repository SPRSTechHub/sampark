import 'package:flutter/material.dart';
import 'package:sampark/model/emipendings.dart';
import 'package:sampark/utils/api.dart';


class PendingEmis extends StatefulWidget {
  const PendingEmis({Key? key, required this.loanno}) : super(key: key);
  final String loanno;

  @override
  State<PendingEmis> createState() => _PendingEmisState();
}

class _PendingEmisState extends State<PendingEmis> {
  List<Pendingloanemi>? emidata;

  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    emidata = await getPendingEmi(widget.loanno, 'SMERR09', '17-07-2022');
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
                      borderRadius: BorderRadius.circular(15.0),
                      color: const Color.fromARGB(228, 0, 43, 122)),
                  child: ListTile(
                      onTap: () {
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmiProfile(
                                ccode: emidata![index].date,
                                loanno: emidata![index].loanNo),
                          ),
                        ); */
                      },
                      leading: const CircleAvatar(
                        //  radius: 100,
                        backgroundImage:
                            AssetImage('assets/images/error_logo.png'),
                      ),
                      title: Text(
                        emidata![index].emiAmount,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        children: [
                          Text(
                            textAlign: TextAlign.left,
                            'M: ${emidata![index].loanNo}',
                            style: const TextStyle(
                              color: Colors.white60,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Loan:${emidata![index].emiAmount}',
                                style: const TextStyle(
                                  color: Colors.white60,
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
