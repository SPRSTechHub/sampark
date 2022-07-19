// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../utils/ad_helper.dart';
import '../utils/api.dart';

class DocVrf extends StatefulWidget {
  final String? ccode;
  const DocVrf({Key? key, required this.ccode}) : super(key: key);
  @override
  State<DocVrf> createState() => _DocVrfState();
}

class _DocVrfState extends State<DocVrf> {
  bool showSpinner = false;
  File? image;
  File? imageAdhaar;
  File? imagePan;

  final ImagePicker _picker = ImagePicker();
  final ImagePicker _pickerPan = ImagePicker();
  final ImagePicker _pickerAdhaar = ImagePicker();

  int uploadStat = 0;

  final TextEditingController _controllerAdhaarTxt = TextEditingController();
  final TextEditingController _controllerPanTxt = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();
  String? custCode;
  bool panUploadStatus = false;
  bool adhaarUploadStatus = false;
  RewardedAd? rewardedAd;

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    custCode = widget.ccode ?? 'null';
    uploadStat;
    super.initState();
  }

  @override
  void dispose() {
    mobileController.dispose();
    _controllerPanTxt.dispose();
    _controllerAdhaarTxt.dispose();
    panUploadStatus = false;
    adhaarUploadStatus = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.indigo[900],
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Material(
                    elevation: 8,
                    color: Colors.indigo[800],
                    borderRadius: BorderRadius.circular(15.0),
                    child: Column(
                      children: [
                        Container(
                          height: 80,
                          width: MediaQuery.of(context).size.width * 0.9,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(10), // radius of 10
                            color: Colors.indigoAccent[400],
                          ),
                          child: TextFormField(
                            readOnly: false,
                            onChanged: (value) async {
                              if (value.isEmpty || value.length != 10) {
                                setState(() {
                                  custCode = 'No Custoer found !';
                                });
                              } else {
                                var response = await getCust(value);
                                if (response['data'] != null) {
                                  setState(() {
                                    custCode = response['data']['cust_code'];
                                  });
                                } else {
                                  setState(() {
                                    custCode = 'No Custoer found !';
                                  });
                                }
                              }
                            },
                            obscureText: false,
                            maxLength: 10,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.blue,
                              contentPadding: const EdgeInsets.all(12),
                              prefixIcon: const Icon(
                                Icons.phone_android_sharp,
                                color: Colors.white,
                              ),
                              labelText: 'Enter Mobile Number',
                              labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 217, 202, 238),
                              ),
                              suffixIcon: IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.white),
                                  onPressed: () => setState(() {
                                        mobileController.text = '';
                                      })),
                            ),
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.phone,
                            controller: mobileController,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length != 10) {
                                Get.snackbar(
                                  "Alert",
                                  'Invalid Entry',
                                  colorText: Colors.white,
                                  icon: const Icon(LineariconsFree.alarm,
                                      color: Colors.white),
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.blue,
                                );
                                return 'Mobile Number must be of 10 digit';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text('$custCode'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Builder(builder: (context) {
                  if (custCode == null || matchCustomer(custCode!) != 'MDC') {
                    return Material(
                      elevation: 8,
                      color: Colors.amberAccent[200],
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        height: 220,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: RichText(
                          text: const TextSpan(
                            text:
                                'Don\'t look like a Customer Code! Are you enter right Mobile number?\n Enter correct Mobile number again and press anywhere to Start checking.',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Material(
                          elevation: 8,
                          color: Colors.indigo[800],
                          borderRadius: BorderRadius.circular(15.0),
                          child: Builder(builder: (context) {
                            if (image != null) {
                              return SizedBox(
                                height: 120,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 80,
                                      margin: const EdgeInsets.all(6),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.file(
                                          image!,
                                          width: 80.0,
                                          height: 80.0,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Text('Upload Customer face'),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (image != null) {
                                                      image = null;
                                                    }
                                                  });
                                                },
                                                child: const Text('Clear')),
                                            getWidget(),
                                          ],
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              );
                            } else {
                              return SizedBox(
                                height: 120,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 120,
                                      margin: const EdgeInsets.all(6),
                                      child: Lottie.network(
                                          'https://assets8.lottiefiles.com/packages/lf20_hksn6fxa.json'),
                                    ),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Text(
                                            'Upload Customer face photo'),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  getImage(ImageSource.camera);
                                                },
                                                child: const Text('Camera')),
                                            ElevatedButton(
                                                onPressed: () {
                                                  getImage(ImageSource.gallery);
                                                },
                                                child: const Text('Gallary'))
                                          ],
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              );
                            }
                          }),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Material(
                          elevation: 8,
                          color: Colors.indigo[800],
                          borderRadius: BorderRadius.circular(15.0),
                          child: Builder(builder: (context) {
                            if (imagePan != null) {
                              return SizedBox(
                                height: 120,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 80,
                                      margin: const EdgeInsets.all(6),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.file(
                                          imagePan!,
                                          width: 80.0,
                                          height: 80.0,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Text('Upload Pan'),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (imagePan != null) {
                                                      imagePan = null;
                                                      uploadStat == 1;
                                                    }
                                                  });
                                                },
                                                child: const Text('Clear')),
                                            panUploadStatus
                                                ? const Icon(
                                                    LineariconsFree
                                                        .checkmark_cicle,
                                                    color: Colors.green)
                                                : ElevatedButton(
                                                    onPressed: () {
                                                      uploadPan(
                                                          custCode, imagePan!);
                                                    },
                                                    child:
                                                        const Text('Upload')),
                                          ],
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              );
                            } else {
                              return SizedBox(
                                height: 120,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 120,
                                      margin: const EdgeInsets.all(6),
                                      child: Lottie.network(
                                          'https://assets8.lottiefiles.com/packages/lf20_hksn6fxa.json'),
                                    ),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Text('Upload Pan Card'),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  getPan(ImageSource.camera);
                                                },
                                                child: const Text('Camera')),
                                            ElevatedButton(
                                                onPressed: () {
                                                  getPan(ImageSource.gallery);
                                                },
                                                child: const Text('Gallary'))
                                          ],
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              );
                            }
                          }),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Material(
                          elevation: 8,
                          color: Colors.indigo[800],
                          borderRadius: BorderRadius.circular(15.0),
                          child: Builder(builder: (context) {
                            if (imageAdhaar != null) {
                              return SizedBox(
                                height: 120,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 80,
                                      margin: const EdgeInsets.all(6),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.file(
                                          imageAdhaar!,
                                          width: 80.0,
                                          height: 80.0,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Text('Upload Adhaar'),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (imageAdhaar != null) {
                                                      imageAdhaar = null;
                                                    }
                                                  });
                                                },
                                                child: const Text('Clear')),
                                            adhaarUploadStatus
                                                ? const Icon(
                                                    LineariconsFree
                                                        .checkmark_cicle,
                                                    color: Colors.green)
                                                : ElevatedButton(
                                                    onPressed: () {
                                                      uploadAdhaar(custCode,
                                                          imageAdhaar!);
                                                    },
                                                    child:
                                                        const Text('Upload')),
                                          ],
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              );
                            } else {
                              return SizedBox(
                                height: 120,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 120,
                                      margin: const EdgeInsets.all(6),
                                      child: Lottie.network(
                                          'https://assets8.lottiefiles.com/packages/lf20_hksn6fxa.json'),
                                    ),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Text('Upload Adhaar Card'),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  getAdhaar(ImageSource.camera);
                                                },
                                                child: const Text('Camera')),
                                            ElevatedButton(
                                                onPressed: () {
                                                  getAdhaar(
                                                      ImageSource.gallery);
                                                },
                                                child: const Text('Gallary'))
                                          ],
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              );
                            }
                          }),
                        ),
                      ],
                    );
                  }
                }),
              ],
            )),
      ),
    );
  }

  Future<void> getImage(source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {});
    }
  }

  Future uploadImg(custCode, File? image) async {
    //if (image != null && uploadStat == 0 && custCode != null) {
    if (image != null && custCode != null) {
      setState(() {
        showSpinner = true;
        //uploadStat = 1;
      });
      var profileUpload = await uploadImage(custCode, image);
      if (profileUpload != false && profileUpload['status'] == 0) {
        setState(() {
          showSpinner = false;
          uploadStat = 0;
          Get.snackbar(
            "Alert",
            profileUpload['msg'],
            colorText: Colors.white,
            icon: const Icon(LineariconsFree.alarm, color: Colors.white),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red[900],
          );
        });
      } else if (profileUpload != false && profileUpload['status'] == 1) {
        setState(() {
          showSpinner = false;
          uploadStat = 1;
          Get.snackbar(
            "Alert",
            profileUpload['msg'],
            colorText: Colors.white,
            icon: const Icon(LineariconsFree.alarm, color: Colors.white),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue,
          );
        });
      } else {
        setState(() {
          Get.snackbar(
            "Alert",
            "Upload Failed!",
            colorText: Colors.white,
            icon: const Icon(LineariconsFree.alarm, color: Colors.white),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red[900],
          );
          showSpinner = false;
        });
      }
    } else {
      showSpinner = false;
    }
  }

  Future<void> getPan(source) async {
    final pickedFile =
        await _pickerPan.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      imagePan = File(pickedFile.path);
      setState(() {});
    }
  }

  Future uploadPan(custCode, File? imagePan) async {
    //if (imagePan != null && uploadStat == 1) {
    if (imagePan != null && custCode != null) {
      Get.defaultDialog(
        title: 'Pan Number',
        titleStyle: TextStyle(color: Colors.blue[900], fontSize: 16),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter(RegExp(r'[0-9A-Z]'), allow: true)
                ],
                focusNode: focusNode,
                autofocus: true,
                keyboardType: TextInputType.text,
                controller: _controllerPanTxt,
                textCapitalization: TextCapitalization.characters,
                maxLength: 10,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: 'Enter number here',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Pan Number';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showSpinner = true;
                  });
                  var pan = _controllerPanTxt.text;
                  if (pan.length != 10) {
                    showSpinner = false;
                    Get.snackbar(
                      "Alert",
                      ' Invalid Pan!',
                      colorText: Colors.white,
                      icon: const Icon(LineariconsFree.alarm,
                          color: Colors.white),
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.blue,
                    );
                  } else {
                    final formatPanCard = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}');
                    if (formatPanCard.hasMatch(pan) != true) {
                      showSpinner = false;
                      Get.snackbar(
                        "Alert",
                        ' Invalid Pan!',
                        colorText: Colors.white,
                        icon: const Icon(LineariconsFree.alarm,
                            color: Colors.white),
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.blue,
                      );
                    } else {
                      Get.back();
                      setState(() async {
                        showSpinner = true;
                        panUploadStatus = true;

                        var panUpload =
                            await uploadDocs(custCode, pan, 'pan', imagePan);
                        if (panUpload != false && panUpload['status'] == 0) {
                          setState(() {
                            rewardLoader();
                            showSpinner = false;
                            uploadStat = 2;
                            Get.snackbar(
                              "Alert",
                              panUpload['msg'],
                              colorText: Colors.white,
                              icon: const Icon(LineariconsFree.alarm,
                                  color: Colors.white),
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red[900],
                            );
                          });
                        } else if (panUpload != false &&
                            panUpload['status'] == 1) {
                          setState(() {
                            showSpinner = false;
                            uploadStat = 2;
                            Get.snackbar(
                              "Alert",
                              panUpload['msg'],
                              colorText: Colors.white,
                              icon: const Icon(LineariconsFree.alarm,
                                  color: Colors.white),
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.blue,
                            );
                          });
                        } else {
                          setState(() {
                            Get.snackbar(
                              "Alert",
                              "Upload Failed!",
                              colorText: Colors.white,
                              icon: const Icon(LineariconsFree.alarm,
                                  color: Colors.white),
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red[900],
                            );
                            showSpinner = false;
                          });
                        }
                      });
                    }
                  }
                },
                child: const Text('Proceed'),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.indigoAccent,
      );
    } else {
      Get.snackbar(
        "Alert",
        'Complete 1st step first!',
        colorText: Colors.white,
        icon: const Icon(LineariconsFree.alarm, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[900],
      );
      showSpinner = false;
    }
  }

  Future<void> getAdhaar(source) async {
    final pickedFile =
        await _pickerAdhaar.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      imageAdhaar = File(pickedFile.path);
      setState(() {});
    }
  }

  Future uploadAdhaar(custCode, File? imageAdhaar) async {
    //  if (imageAdhaar != null && uploadStat == 2) {
    if (imageAdhaar != null && custCode != null) {
      Get.defaultDialog(
        title: 'Adhaar Number',
        titleStyle: TextStyle(color: Colors.blue[900], fontSize: 16),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _controllerAdhaarTxt,
                textCapitalization: TextCapitalization.characters,
                maxLength: 12,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: 'Enter number here',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Adhaar Number';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showSpinner = true;
                  });
                  var adhaar = _controllerAdhaarTxt.text;
                  if (adhaar.length != 12) {
                    showSpinner = false;
                    Get.snackbar(
                      "Alert",
                      'Invalid Adhaar!',
                      colorText: Colors.white,
                      icon: const Icon(LineariconsFree.alarm,
                          color: Colors.white),
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.blue,
                    );
                  } else {
                    Get.back();
                    setState(() async {
                      showSpinner = true;
                      panUploadStatus = true;
                      uploadStat == 3;
                      var adhaarUpload = await uploadDocs(
                          custCode, adhaar, 'adhaar', imageAdhaar);

                      if (adhaarUpload != false &&
                          adhaarUpload['status'] == 0) {
                        setState(() {
                          showSpinner = false;
                          //uploadStat = 2;
                          Get.snackbar(
                            "Alert",
                            adhaarUpload['msg'],
                            colorText: Colors.white,
                            icon: const Icon(LineariconsFree.alarm,
                                color: Colors.white),
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red[900],
                          );
                        });
                      } else if (adhaarUpload != false &&
                          adhaarUpload['status'] == 1) {
                        setState(() {
                          rewardLoader();
                          showSpinner = false;
                          uploadStat = 3;
                          Get.snackbar(
                            "Alert",
                            adhaarUpload['msg'],
                            colorText: Colors.white,
                            icon: const Icon(LineariconsFree.alarm,
                                color: Colors.white),
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.blue,
                          );
                        });
                      } else {
                        setState(() {
                          Get.snackbar(
                            "Alert",
                            "Upload Failed!",
                            colorText: Colors.white,
                            icon: const Icon(LineariconsFree.alarm,
                                color: Colors.white),
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red[900],
                          );
                          showSpinner = false;
                        });
                      }
                    });
                  }
                },
                child: const Text('Proceed'),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.indigoAccent,
      );
    } else {
      Get.snackbar(
        "Alert",
        'Complete 2nd step first!',
        colorText: Colors.white,
        icon: const Icon(LineariconsFree.alarm, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[900],
      );
      showSpinner = false;
    }
  }

  Widget getWidget() {
    if (uploadStat == 1) {
      return const Icon(LineariconsFree.checkmark_cicle, color: Colors.green);
    } else {
      return ElevatedButton(
          onPressed: () {
            uploadImg(custCode, image!);
            rewardLoader();
          },
          child: const Text('Upload'));
    }
  }

  matchCustomer(String custCode) {
    String str = custCode;
    str = str.substring(0, 3);
    return str;
  }

  rewardLoader() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
        rewardedAd = ad;
        rewardedAd?.show(
          onUserEarnedReward: ((ad, reward) {
            debugPrint("${reward.amount}");
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
