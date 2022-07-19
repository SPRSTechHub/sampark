import 'package:flutter/material.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sampark/app.dart';
import 'package:sampark/utils/ad_helper.dart';
import 'package:sampark/utils/api.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:sizer/sizer.dart';

class AddLoan extends StatefulWidget {
  const AddLoan({Key? key}) : super(key: key);

  @override
  State<AddLoan> createState() => _AddLoanState();
}

class _AddLoanState extends State<AddLoan> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> formData;
  String? custCode;
  String selectTunnure = "";
  String selectPurpose = "";
  String date = "";
  DateTime selectedDate = DateTime.now();

  final mobileController = TextEditingController();
  final custcode = TextEditingController();
  final loandate = TextEditingController();
  final loanAmount = TextEditingController();
  final emiamount = TextEditingController();
  final purposes = TextEditingController();
  final tennure = TextEditingController();

  RewardedAd? rewardedAd;

  @override
  void initState() {
    if (SizerUtil.deviceType == DeviceType.mobile) {
      _runAds();
    }
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    mobileController.dispose();
    custcode.dispose();
    loandate.dispose();
    loanAmount.dispose();
    emiamount.dispose();
    //
    tennure.dispose();
    purposes.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Center(
        child: Container(
          color: Colors.indigo[900],
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.indigo[900],
                  height: 90,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Home(
                                      title: 'Add Customer', page: 4)));
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
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
                                Icons.account_box_outlined,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                            const Text('Add Customer',
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
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
                                Icons.attach_file_rounded,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                            const Text('Add Docs',
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                            begin: Alignment(.15, .045),
                            end: Alignment(-1, -1),
                            colors: [
                              Color.fromRGBO(0, 0, 9, 1),
                              Color.fromARGB(255, 25, 0, 48)
                            ],
                          )),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              onChanged: (value) async {
                                                if (value.isEmpty ||
                                                    value.length != 10) {
                                                } else {
                                                  var response =
                                                      await getCust(value);
                                                  if (response['data'] !=
                                                      null) {
                                                    custcode.text =
                                                        response['data']
                                                            ['cust_code'];
                                                    custCode = response['data']
                                                        ['cust_code'];
                                                  } else {
                                                    custcode.text = '';
                                                    custCode = null;
                                                  }
                                                }
                                              },
                                              obscureText: false,
                                              decoration:
                                                  CommonStyle.textFieldStyle(
                                                labelTextStr: "Customer Mobile",
                                                hintTextStr:
                                                    "10 digit mobile number",
                                                icon: const Icon(
                                                  Icons.phone_android_sharp,
                                                  color: Color(0xFFEBB818),
                                                ),
                                              ),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              textAlign: TextAlign.start,
                                              keyboardType: TextInputType.phone,
                                              controller: mobileController,
                                              maxLength: 10,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty ||
                                                    value.length != 10) {
                                                  return 'Mobile Number must be of 10 digit';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Builder(builder: (context) {
                                      if (custCode == null ||
                                          matchCustomer(custCode!) != 'MDC') {
                                        return Container(
                                          height: 25,
                                          color: Colors.red,
                                          child: const Text(
                                            'Customer Code not in our system',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: TextFormField(
                                                obscureText: false,
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.all(12),
                                                  labelText: 'Customer Code',
                                                  labelStyle: const TextStyle(
                                                      color: Colors.white),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  prefixIcon: const IconTheme(
                                                      data: IconThemeData(
                                                          color: Colors.white),
                                                      child: Icon(Icons
                                                          .account_box_outlined)),
                                                  suffixIcon: custcode
                                                          .text.isNotEmpty
                                                      ? InkWell(
                                                          onTap: () => setState(
                                                            () {
                                                              Future.delayed(
                                                                  const Duration(
                                                                      seconds:
                                                                          1),
                                                                  () async {
                                                                var resp = await getCbil(
                                                                    'mobile',
                                                                    mobileController
                                                                        .text);
                                                                // ignore: avoid_print
                                                                //{}
                                                                if (resp !=
                                                                    null) {
                                                                  Get.bottomSheet(
                                                                    customerCard(
                                                                        context:
                                                                            context,
                                                                        profileurl:
                                                                            'https://play.liveipl.online/uploads/149377355.jpg',
                                                                        pan:
                                                                            '1',
                                                                        adhaar:
                                                                            '1',
                                                                        count:
                                                                            '1',
                                                                        cbil:
                                                                            '800',
                                                                        profile:
                                                                            '1'),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    elevation:
                                                                        0,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                  );
                                                                }
                                                                print(
                                                                    'gud: $resp');
                                                              });
                                                            },
                                                          ),
                                                          child: const Icon(
                                                            Icons
                                                                .credit_card_outlined,
                                                            color: Colors.amber,
                                                            size: 22,
                                                          ),
                                                        )
                                                      : InkWell(
                                                          onTap: () {
                                                            // print('okay');
                                                          },
                                                          child: const Icon(
                                                            Icons
                                                                .date_range_outlined,
                                                            color: Colors.amber,
                                                            size: 22,
                                                          ),
                                                        ),
                                                ),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                textAlign: TextAlign.start,
                                                controller: custcode,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty ||
                                                      value.length < 3) {
                                                    return 'Name must be more than 4 charater';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  'loandate',
                                                  const Duration(
                                                      milliseconds: 2000),
                                                  () => setState(() {}),
                                                ),
                                                controller: loandate,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.blue,
                                                            width: 1.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  labelText:
                                                      'Loan Sanction Date',
                                                  labelStyle: const TextStyle(
                                                      color: Colors.white),
                                                  hintText: 'dd-mm-yyyy',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.white30),
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  filled: true,
                                                  prefixIcon: const Icon(
                                                    Icons
                                                        .perm_contact_calendar_outlined,
                                                    color: Color(0xFFEBB818),
                                                  ),
                                                  suffixIcon: loandate
                                                          .text.isNotEmpty
                                                      ? InkWell(
                                                          onTap: () => setState(
                                                            () => loandate
                                                                .clear(),
                                                          ),
                                                          child: const Icon(
                                                            Icons.clear,
                                                            color: Color(
                                                                0xFFFF0303),
                                                            size: 22,
                                                          ),
                                                        )
                                                      : InkWell(
                                                          onTap: () {
                                                            _selectDate(
                                                                context);
                                                          },
                                                          child: const Icon(
                                                            Icons
                                                                .date_range_outlined,
                                                            color: Colors.amber,
                                                            size: 22,
                                                          ),
                                                        ),
                                                ),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                textAlign: TextAlign.start,
                                                keyboardType:
                                                    TextInputType.datetime,
                                                maxLength: 10,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter valid Date';
                                                  } else if (!RegExp(
                                                          r'^(3[01]|[12][0-9]|0[1-9])-(1[0-2]|0[1-9])-[0-9]{4}$')
                                                      .hasMatch(value)) {
                                                    return 'Please enter valid Date';
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: TextFormField(
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  'loan_txt',
                                                  const Duration(
                                                      milliseconds: 2000),
                                                  () => setState(() {}),
                                                ),
                                                obscureText: false,
                                                decoration:
                                                    CommonStyle.textFieldStyle(
                                                  labelTextStr:
                                                      "Principle Amount",
                                                  hintTextStr:
                                                      "Enter Loan amount taken",
                                                  icon: const Icon(
                                                    Icons.person,
                                                  ),
                                                ),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                textAlign: TextAlign.start,
                                                controller: loanAmount,
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty ||
                                                      value.length < 3) {
                                                    return 'Name must be more than 4 charater';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 0),
                                                decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: TextFormField(
                                                  onChanged: (_) =>
                                                      EasyDebounce.debounce(
                                                    'loan_txt',
                                                    const Duration(
                                                        milliseconds: 2000),
                                                    () => setState(() {}),
                                                  ),
                                                  obscureText: false,
                                                  decoration: CommonStyle
                                                      .textFieldStyle(
                                                    labelTextStr: "Tennure",
                                                    hintTextStr:
                                                        "Set Total Weeks",
                                                    icon: const Icon(
                                                      Icons
                                                          .calendar_view_day_outlined,
                                                    ),
                                                  ),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                  textAlign: TextAlign.start,
                                                  controller: tennure,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty ||
                                                        value.length != 2) {
                                                      return 'Must be 2 digits';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                /* DropDownField(
                            value: selectTunnure,
                            required: true,
                            enabled: true,
                            itemsVisibleInDropdown: 3,
                            strict: true,
                            labelText: 'Select Tennures',
                            labelStyle: const TextStyle(color: Colors.white),
                            icon: const Icon(Icons.account_balance),
                            items: teunures,
                            onValueChanged: (value) {
                              setState(() {
                                selectTunnure = value;
                              });
                            },
                          ), */
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 0),
                                                decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: TextFormField(
                                                  onChanged: (_) =>
                                                      EasyDebounce.debounce(
                                                    'loan_txt',
                                                    const Duration(
                                                        milliseconds: 2000),
                                                    () => setState(() {}),
                                                  ),
                                                  obscureText: false,
                                                  decoration: CommonStyle
                                                      .textFieldStyle(
                                                    labelTextStr: "Purpose",
                                                    hintTextStr:
                                                        "Enter Reason for Loan",
                                                    icon: const Icon(
                                                      Icons.expand_circle_down,
                                                    ),
                                                  ),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                  textAlign: TextAlign.start,
                                                  controller: purposes,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty ||
                                                        value.length >= 12) {
                                                      return 'Minimum 5 Characters';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                /* DropDownField(
                            value: selectPurpose,
                            //  controller: selectPurpose,
                            required: true,
                            enabled: true,
                            itemsVisibleInDropdown: 3,
                            strict: true,
                            labelText: 'Select Purpose',
                            labelStyle: const TextStyle(color: Colors.white),
                            icon: const Icon(Icons.mark_chat_read),
                            items: purposes,
                            onValueChanged: (value) {
                              setState(() {
                                selectPurpose = value;
                              });
                            },
                          ), */
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                onChanged: (_) =>
                                                    EasyDebounce.debounce(
                                                  'emi_amnt',
                                                  const Duration(
                                                      milliseconds: 2000),
                                                  () => setState(() {}),
                                                ),
                                                obscureText: false,
                                                decoration:
                                                    CommonStyle.textFieldStyle(
                                                  labelTextStr: "Emi Amount",
                                                  icon: const Icon(
                                                    Icons.phone_android_sharp,
                                                    color: Color(0xFFEBB818),
                                                  ),
                                                ),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                textAlign: TextAlign.start,
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: emiamount,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Emi Amount';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16.0),
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    setState(() {
                                                      showSpinner = true;
                                                    });
                                                    var mobile =
                                                        mobileController.text;
                                                    var custCode =
                                                        custcode.text;
                                                    var emiAmnt =
                                                        emiamount.text;
                                                    var loanDate =
                                                        loandate.text;
                                                    var loanAmnt =
                                                        loanAmount.text;
                                                    var purpose = purposes.text;
                                                    var tenure = tennure.text;
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        action: SnackBarAction(
                                                          label: 'Close',
                                                          onPressed: () {
                                                            // Code to execute.
                                                          },
                                                        ),
                                                        content: const Text(
                                                            'Processing...'),
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    1500),
                                                        width: 280.0,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 8.0,
                                                        ),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25.0),
                                                        ),
                                                      ),
                                                    );

                                                    var response =
                                                        await addLoanFunc(
                                                            mobile,
                                                            custCode,
                                                            emiAmnt,
                                                            loanDate,
                                                            loanAmnt,
                                                            purpose,
                                                            tenure);

                                                    if (response != false ||
                                                        response['status'] ==
                                                            1) {
                                                      setState(() {
                                                        showSpinner = false;
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            action:
                                                                SnackBarAction(
                                                              label: 'Close',
                                                              onPressed: () {
                                                                // Code to execute.
                                                              },
                                                            ),
                                                            content: Text(
                                                                response[
                                                                    'msg']),
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        1500),
                                                            width: 280.0,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 8.0,
                                                            ),
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25.0),
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                      rewardLoader();
                                                      Get.to(const Home(
                                                          title: 'Sampark',
                                                          page: 0));
                                                    } else {
                                                      setState(() {
                                                        showSpinner = false;
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                              content: Text(
                                                                  response[
                                                                      'msg'])),
                                                        );
                                                      });
                                                    }
                                                  }
                                                },
                                                child: const Text('Submit'),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }),
                                  ],
                                ),
                              ),
                              Container(
                                height: 500,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                /*    if (SizerUtil.deviceType == DeviceType.mobile)
                  if (_isBannerAdReady)
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: _bannerAd.size.width.toDouble(),
                        height: _bannerAd.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd),
                      ),
                    ), */
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _runAds() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          // print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
  }

  matchCustomer(String custCode) {
    String str = custCode;
    str = str.substring(0, 3);
    return str;
  }

  Future _selectDate(BuildContext context) async {
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1980),
      lastDate: DateTime(2099),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        loandate.text = formatter.format(selected);
      });
    }
  }

  rewardLoader() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
        rewardedAd = ad;
        rewardedAd?.show(
          onUserEarnedReward: ((ad, reward1) {
            debugPrint("${reward1.amount}");
          }),
        );
        rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
          },
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            // load func for completation of adScrn view
          },
        );
      }, onAdFailedToLoad: (err) {
        debugPrint(err.message);
      }),
    );
  }
}

//'profile_url': 'https://play.liveipl.online/uploads/149377355.jpg', 'profile': '1', 'pan': '1', 'adhaar': '1', 'count': '1', 'cbil': '800'
// ignore: camel_case_types
class customerCard extends StatelessWidget {
  final String? profileurl;
  final String? profile;
  final String? pan;
  final String? adhaar;
  final String? count;
  final String? cbil;

  const customerCard({
    Key? key,
    required this.context,
    this.profile,
    this.profileurl,
    this.pan,
    this.adhaar,
    this.count,
    this.cbil,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                color: Colors.grey,
                child: Image.network(
                    'https://images.unsplash.com/photo-1653778005824-4bc7dc887603',
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    fit: BoxFit.cover),
              ),
              Positioned(
                  top: 120,
                  child: CircleAvatar(
                    radius: 65,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(profileurl!),
                  ))
            ],
          ),
          const SizedBox(height: 60),
          Center(
            child: Text(
              '$profile',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              verificationDocsIcon(
                  LineariconsFree.license,
                  profile == '1'
                      ? LineariconsFree.checkmark_cicle
                      : LineariconsFree.cross_circle,
                  'profile'),
              verificationDocsIcon(
                  LineariconsFree.license,
                  adhaar == '1'
                      ? LineariconsFree.checkmark_cicle
                      : LineariconsFree.cross_circle,
                  'Adhaar'),
              verificationDocsIcon(
                  LineariconsFree.license,
                  pan == '1'
                      ? LineariconsFree.checkmark_cicle
                      : LineariconsFree.cross_circle,
                  'Pan'),
            ],
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () {
              Get.back();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

Widget verificationDocsIcon(IconData icon, IconData icon2, String? txtdata) {
  return Material(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    clipBehavior: Clip.hardEdge,
    color: Colors.black87,
    child: InkWell(
        onTap: () {},
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(4),
            width: 110,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 18),
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(
                      icon2,
                      size: 18,
                      color: Colors.blue,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(txtdata!),
              ],
            ),
          ),
        )),
  );
}

class CommonStyle {
  static InputDecoration textFieldStyle(
      {String labelTextStr = "", String hintTextStr = "", Icon? icon}) {
    var myFocusNode = FocusNode();
    return InputDecoration(
      contentPadding: const EdgeInsets.all(12),
      labelText: labelTextStr,
      labelStyle:
          TextStyle(color: myFocusNode.hasFocus ? Colors.blue : Colors.white),
      hintText: hintTextStr,
      hintStyle:
          TextStyle(color: myFocusNode.hasFocus ? Colors.blue : Colors.white30),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      prefixIcon: IconTheme(
          data: const IconThemeData(color: Colors.white),
          child: icon ?? const Icon(Icons.done)),
    );
  }
}

List<String> teunures = ['24', '48', '56'];

List<String> purposes = [
  'Home Loan',
  'Business Loan',
  'Personal Loan',
  'Oth1',
  'Oth2',
  'Oth3',
  'Oth4',
  'Oth5',
  'Oth6'
];