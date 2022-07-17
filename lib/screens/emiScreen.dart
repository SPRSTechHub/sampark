import 'package:flutter/material.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:sampark/utils/utils.dart';
import 'package:sampark/widgets/pending_emi_data.dart';

class EmiProfile extends StatefulWidget {
  const EmiProfile({Key? key, required this.ccode, required this.loanno})
      : super(key: key);
  final String ccode;
  final String loanno;
  @override
  State<EmiProfile> createState() => _EmiProfileState();
}

class _EmiProfileState extends State<EmiProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.emiScaffoldBgColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsetsDirectional.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.all(4.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColor.emiContanerTransparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.all(4.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Name',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                widget.ccode,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Hello World',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Hello World',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          /* Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const Home(title: 'Sampark', page: 3)));
                   */
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 1,
                                    color: Color(0xFF033D8D),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Linecons.user,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                            const Text('Add New')
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 1,
                                    color: Color(0xFF033D8D),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Linecons.inbox,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                            const Text('Doc Upload')
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 1,
                                    color: Color(0xFF033D8D),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Linecons.wallet,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                            const Text('Payments')
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 1,
                                    color: Color(0xFF033D8D),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Linecons.note,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                            const Text('Reports')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsetsDirectional.all(4.0),
                    decoration: BoxDecoration(
                      color: AppColor.emiContanerTransparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: PendingEmis(loanno: widget.loanno),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/*
Container(
      child: Text(widget.ccode),
    );
    */