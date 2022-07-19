// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sampark/app.dart';
import 'package:sampark/utils/api.dart';
import 'package:sampark/utils/prefs.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();

  final emplcode = TextEditingController();
  final password = TextEditingController();
  late dynamic fcmToken;

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  void dispose() {
    emplcode.dispose();
    password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: const Color(0xFF081726),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Lottie.asset(
                    'assets/images/abc.json',
                    width: MediaQuery.of(context).size.width,
                    height: 220,
                    fit: BoxFit.cover,
                    animate: true,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              obscureText: false,
                              decoration: CommonStyle.textFieldStyle(
                                labelTextStr: "Employee code",
                                icon: const Icon(
                                  LineariconsFree.user_1,
                                  color: Color(0xFFEBB818),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              controller: emplcode,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Employee code missing!';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              obscureText: false,
                              decoration: CommonStyle.textFieldStyle(
                                labelTextStr: "Password",
                                icon: const Icon(
                                  LineariconsFree.lock_1,
                                  color: Color(0xFFEBB818),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              controller: password,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password missing!';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 80,
                            width: 120,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  var emplcodeT = emplcode.text;
                                  var passwordT = password.text;
                                  var tokenT = fcmToken;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      action: SnackBarAction(
                                        label: 'Close',
                                        onPressed: () {
                                          // Code to execute.
                                        },
                                      ),
                                      content: const Text('Processing...'),
                                      duration:
                                          const Duration(milliseconds: 1500),
                                      width: 280.0,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                    ),
                                  );

                                  var response = await authUserCheck(
                                      emplcodeT, passwordT, tokenT);

                                  if (response['status'] == 1) {
                                    if (response['data'][0]['emp_code'] != '') {
                                      setData(response['data'][0]['emp_code']);
                                    }

                                    setState(() {
                                      showSpinner = false;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(response['msg']),
                                          duration: const Duration(
                                              milliseconds: 1500),
                                          width: 280.0,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        ),
                                      );
                                    });
                                    Get.to(() => const Home(
                                          page: 0,
                                          title: 'Sampark',
                                        ));
                                  } else {
                                    setState(() {
                                      showSpinner = false;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(response['msg'])),
                                      );
                                    });
                                  }
                                }
                              },
                              child: const Text('Login'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getToken() async {
    fcmToken = await FirebaseMessaging.instance.getToken();
  }

  setData(String emplcodeT) async {
    await UserSimplePreferences.setUsername(emplcodeT);
    await UserSimplePreferences.setLogin(1);
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
