import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:intl/intl.dart';
import 'package:sampark/app.dart';
import 'package:sampark/screens/addDocs.dart';
import 'package:sampark/utils/api.dart';
import 'package:sizer/sizer.dart';

import '../utils/ad_helper.dart';

class AddNew extends StatefulWidget {
  const AddNew({Key? key}) : super(key: key);

  @override
  State<AddNew> createState() => _AddNewState();
}

Future<InitializationStatus> _initGoogleMobileAds() {
  return MobileAds.instance.initialize();
}

class _AddNewState extends State<AddNew> {
  bool showSpinner = false;
  // Set up Global Form Keys //
  final _formKey = GlobalKey<FormState>();
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  // Set up Form inputs //
  final f_name_Controller = TextEditingController();
  final l_name_Controller = TextEditingController();
  final address_Controller = TextEditingController();
  final mobile_Controller = TextEditingController();
  final alt_mobile_Controller = TextEditingController();
  final dob_Controller = TextEditingController();
  final gen_Controller = TextEditingController();

  @override
  void initState() {
    if (SizerUtil.deviceType == DeviceType.mobile) {
      _runAds();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (SizerUtil.deviceType == DeviceType.mobile) {
      _bannerAd.dispose();
    }

    f_name_Controller.dispose();
    l_name_Controller.dispose();
    address_Controller.dispose();
    mobile_Controller.dispose();
    alt_mobile_Controller.dispose();
    dob_Controller.dispose();

    super.dispose();
  }

  // Set up Output //
  String message = '';
  String _selectedGender = 'male';
  String date = "";
  DateTime selectedDate = DateTime.now();

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
                                  builder: (context) =>
                                      const Home(title: 'Add Loan', page: 4)));
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
                                Icons.account_balance_outlined,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                            const Text('Add Loan',
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('Emiscreen');
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
                                Icons.card_travel_rounded,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                            const Text('Add EMI',
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
                                              onChanged: (_) =>
                                                  EasyDebounce.debounce(
                                                'f_name',
                                                const Duration(
                                                    milliseconds: 2000),
                                                () => setState(() {}),
                                              ),
                                              obscureText: false,
                                              decoration:
                                                  CommonStyle.textFieldStyle(
                                                labelTextStr: "FIRST NAME",
                                                hintTextStr:
                                                    "Enter Customer First Name",
                                                icon: const Icon(
                                                  Icons.person,
                                                ),
                                              ),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              textAlign: TextAlign.start,
                                              controller: f_name_Controller,
                                              // The validator receives the text that the user has entered.
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty ||
                                                    value.length < 3) {
                                                  return 'Name must be more than 2 charater';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              onChanged: (_) =>
                                                  EasyDebounce.debounce(
                                                'l_name',
                                                const Duration(
                                                    milliseconds: 2000),
                                                () => setState(() {}),
                                              ),
                                              obscureText: false,
                                              decoration:
                                                  CommonStyle.textFieldStyle(
                                                labelTextStr: "LAST NAME",
                                                hintTextStr:
                                                    "Enter Customer Last Name",
                                                icon: const Icon(
                                                  Icons.person,
                                                ),
                                              ),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              textAlign: TextAlign.start,
                                              controller: l_name_Controller,
                                              // The validator receives the text that the user has entered.
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty ||
                                                    value.length < 3) {
                                                  return 'Name must be more than 2 charater';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              onChanged: (_) =>
                                                  EasyDebounce.debounce(
                                                'mobile',
                                                const Duration(
                                                    milliseconds: 2000),
                                                () => setState(() {}),
                                              ),

                                              obscureText: false,
                                              decoration:
                                                  CommonStyle.textFieldStyle(
                                                labelTextStr: "CUSTOMER MOBILE",
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
                                              controller: mobile_Controller,
                                              // The validator receives the text that the user has entered.
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
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              onChanged: (_) =>
                                                  EasyDebounce.debounce(
                                                'alt_mobile',
                                                const Duration(
                                                    milliseconds: 2000),
                                                () => setState(() {}),
                                              ),
                                              keyboardType: TextInputType.phone,
                                              obscureText: false,
                                              decoration:
                                                  CommonStyle.textFieldStyle(
                                                labelTextStr: "ALT MOBILE",
                                                hintTextStr: "Alternate mobile",
                                                icon: const Icon(
                                                  Icons.phone_missed_sharp,
                                                  color: Color(0xFFEBB818),
                                                ),
                                              ),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              textAlign: TextAlign.start,
                                              controller: alt_mobile_Controller,
                                              // The validator receives the text that the user has entered.
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return null;
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              onChanged: (_) =>
                                                  EasyDebounce.debounce(
                                                'address',
                                                const Duration(
                                                    milliseconds: 2000),
                                                () => setState(() {}),
                                              ),
                                              obscureText: false,
                                              decoration:
                                                  CommonStyle.textFieldStyle(
                                                labelTextStr: "ADDRESS",
                                                hintTextStr: "Sreet Address",
                                                icon: const Icon(
                                                  Icons.add_business,
                                                  color: Color(0xFFEBB818),
                                                ),
                                              ),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              textAlign: TextAlign.start,
                                              controller: address_Controller,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter valid Address';
                                                }
                                                return null;
                                              },
                                              keyboardType:
                                                  TextInputType.streetAddress,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        onChanged: (_) => EasyDebounce.debounce(
                                          'dob_Controller',
                                          const Duration(milliseconds: 2000),
                                          () => setState(() {}),
                                        ),
                                        controller: dob_Controller,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.blue, width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          labelText: 'Date of Birth',
                                          labelStyle: const TextStyle(
                                              color: Colors.white),
                                          hintText: 'dd-mm-yyyy',
                                          hintStyle: const TextStyle(
                                              color: Colors.white30),
                                          enabledBorder: InputBorder.none,
                                          filled: true,
                                          prefixIcon: const Icon(
                                            Icons
                                                .perm_contact_calendar_outlined,
                                            color: Color(0xFFEBB818),
                                          ),
                                          suffixIcon: dob_Controller
                                                  .text.isNotEmpty
                                              ? InkWell(
                                                  onTap: () => setState(
                                                    () =>
                                                        dob_Controller.clear(),
                                                  ),
                                                  child: const Icon(
                                                    Icons.clear,
                                                    color: Color(0xFFFF0303),
                                                    size: 22,
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    _selectDate(context);
                                                  },
                                                  child: const Icon(
                                                    Icons.date_range_outlined,
                                                    color: Colors.amber,
                                                    size: 22,
                                                  ),
                                                ),
                                        ),
                                        style: const TextStyle(
                                            color: Colors.white),
                                        textAlign: TextAlign.start,
                                        keyboardType: TextInputType.datetime,
                                        maxLength: 10,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
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
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Select Gender:',
                                          style: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            children: [
                                              Radio<String>(
                                                fillColor: MaterialStateColor
                                                    .resolveWith((states) =>
                                                        Colors.green),
                                                focusColor: MaterialStateColor
                                                    .resolveWith((states) =>
                                                        Colors.green),
                                                value: 'male',
                                                groupValue: _selectedGender,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedGender = value!;
                                                  });
                                                },
                                              ),
                                              const Expanded(
                                                  child: Text(
                                                'Male',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                ),
                                              ))
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            children: [
                                              Radio<String>(
                                                fillColor: MaterialStateColor
                                                    .resolveWith((states) =>
                                                        Colors.green),
                                                focusColor: MaterialStateColor
                                                    .resolveWith((states) =>
                                                        Colors.green),
                                                value: 'female',
                                                groupValue: _selectedGender,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedGender = value!;
                                                  });
                                                },
                                              ),
                                              const Expanded(
                                                  child: Text(
                                                'Female',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                ),
                                              ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              showSpinner = true;
                                            });
                                            var f_name = f_name_Controller.text;
                                            var l_name = l_name_Controller.text;
                                            var mobile = mobile_Controller.text;
                                            var alt_mob =
                                                alt_mobile_Controller.text;
                                            var address =
                                                address_Controller.text;
                                            var dob = dob_Controller.text;
                                            var gen = _selectedGender;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                action: SnackBarAction(
                                                  label: 'Close',
                                                  onPressed: () {
                                                    // Code to execute.
                                                  },
                                                ),
                                                content:
                                                    const Text('Processing...'),
                                                duration: const Duration(
                                                    milliseconds: 1500),
                                                width: 280.0,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                ),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.0),
                                                ),
                                              ),
                                            );
                                            var response =
                                                await customerRegistration(
                                                    f_name,
                                                    l_name,
                                                    mobile,
                                                    alt_mob,
                                                    gen,
                                                    address,
                                                    dob);

                                            if (response != false ||
                                                response['status'] == 1) {
                                              setState(() {
                                                showSpinner = false;
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    action: SnackBarAction(
                                                      label: 'Close',
                                                      onPressed: () {
                                                        // Code to execute.
                                                      },
                                                    ),
                                                    content:
                                                        Text(response['msg']),
                                                    duration: const Duration(
                                                        milliseconds: 1500),
                                                    width: 280.0,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 8.0,
                                                    ),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25.0),
                                                    ),
                                                  ),
                                                );
                                              });

                                              Get.to(DocVrf(
                                                  ccode: response['ccode']));
                                            } else {
                                              setState(() {
                                                showSpinner = false;
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          response['msg'])),
                                                );
                                              });
                                            }
                                          }
                                        },
                                        child: const Text('Next'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (SizerUtil.deviceType == DeviceType.mobile)
                  if (_isBannerAdReady)
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: _bannerAd.size.width.toDouble(),
                        height: _bannerAd.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
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
        dob_Controller.text = formatter.format(selected);
      });
    }
  }

  _runAds() {
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
