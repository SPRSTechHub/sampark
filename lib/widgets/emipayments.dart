import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sampark/utils/api.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:fluttericon/linearicons_free_icons.dart';

import '../screens/agenScreen.dart';
import '../utils/prefs.dart';

class EmiPayModal extends StatefulWidget {
  final String? agentcode;
  final String? emicode;
  final String? emiamnt;
  const EmiPayModal(
      {Key? key,
      required this.agentcode,
      required this.emicode,
      required this.emiamnt})
      : super(key: key);

  @override
  State<EmiPayModal> createState() => _EmiPayModalState();
}

class _EmiPayModalState extends State<EmiPayModal> {
  late TextEditingController emiamnttxt;
  bool isFinished = false;
  bool shouldClose = true;
  final _formKey = GlobalKey<FormState>();
  late dynamic fcmToken;

  @override
  void initState() {
    super.initState();
    fcmToken = UserSimplePreferences.getToken() ?? 'no token';

    emiamnttxt = TextEditingController(text: widget.emiamnt?.toString());
  }

  @override
  void dispose() {
    super.dispose();
    emiamnttxt.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: WillPopScope(
      onWillPop: () async {
        await showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
                  title: const Text('Confirm....?'),
                  actions: <Widget>[
                    CupertinoButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        shouldClose = true;
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: const Text('No'),
                      onPressed: () {
                        shouldClose = false;
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ));
        return shouldClose;
      },
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            backgroundColor: Colors.redAccent.shade400,
            leading: Container(
                //child:Icon:(Icons.close),
                ),
            middle: const Text('EMI SUBMISSION')),
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.amberAccent.shade100,
              height: 100,
              child: const Center(
                child: Text('SAMPARK LOAN PAY',
                    style: TextStyle(
                        fontSize: 35,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.amberAccent.shade100,
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emiamnttxt,
                        autofocus: true,
                        readOnly: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Emi Amount',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          filled: true,
                          fillColor: Colors.black87,
                          prefixIcon: const Icon(LineariconsFree.alarm,
                              color: Colors.red),
                          suffixIcon: const Icon(
                            Icons.close,
                            color: Color(0xFF757575),
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Customer Code: MDCXXXX',
                          style: TextStyle(color: Colors.black, fontSize: 20)),
                      Text('Agent Code: ${widget.agentcode}',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 25)),
                      Text('Invoice No:  ${widget.emicode}',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 25)),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 25),
                          child: SwipeableButtonView(
                              buttonText: "SLIDE TO PAY",
                              buttonWidget: const SizedBox(
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.grey,
                                ),
                              ),
                              activeColor: Colors.red,
                              isFinished: isFinished,
                              onWaitingProcess: () {
                                Future.delayed(const Duration(seconds: 2), () {
                                  setState(() {
                                    isFinished = true;
                                  });
                                });
                              },
                              onFinish: () async {
                                var emiamt = emiamnttxt.text;
                                var emicod = widget.emicode;

                                var resp =
                                    await updateEmi(emicod, emiamt, fcmToken);

                                if (resp == null) {
                                  setState(() {
                                    shouldClose = true;
                                    Navigator.of(context).pop();
                                    isFinished = false;
                                    Get.snackbar('Alert', 'EMI Not Updated!',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.red);
                                  });
                                } else {
                                  if (resp['status'] == 1) {
                                    setState(() {
                                      shouldClose = true;
                                      isFinished = false;

                                      Get.snackbar(
                                          'Alert', 'EMI Updated Successfully!',
                                          snackPosition: SnackPosition.BOTTOM);
                                      Get.to(const AgentScreen());
                                    });
                                  } else {
                                    setState(() {
                                      shouldClose = true;
                                      isFinished = false;

                                      Get.snackbar(
                                          'Alert', 'EMI Updated Successfully!',
                                          snackPosition: SnackPosition.BOTTOM);
                                      Navigator.of(context).pop();
                                    });
                                  }
                                }
/*                                 shouldClose = true;
                                Navigator.of(context)
                                    .pop();
                                     /* Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: const DashboardScreen()));
 */
                                setState(() {
                                  isFinished = false;
                                });
 */
                              }))
                    ],
                  ),
                ),
              ),
            ),
            Container(
              alignment: const Alignment(0.5, 1),
              child: FacebookBannerAd(
                placementId: Platform.isAndroid
                    ? "422049633206700_424121256332871"
                    : "YOUR_IOS_PLACEMENT_ID",
                bannerSize: BannerSize.STANDARD,
                listener: (result, value) {
                  switch (result) {
                    case BannerAdResult.ERROR:
                      print("Error: $value");
                      break;
                    case BannerAdResult.LOADED:
                      print("Loaded: $value");
                      break;
                    case BannerAdResult.CLICKED:
                      print("Clicked: $value");
                      break;
                    case BannerAdResult.LOGGING_IMPRESSION:
                      print("Logging Impression: $value");
                      break;
                  }
                },
              ),
            )
          ],
        )),
      ),
    ));
  }
}
