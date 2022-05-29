/* // ignore_for_file: camel_case_types
// ignore: camel_case_types

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class uploadProfile extends StatefulWidget {
  final String custCode;
  const uploadProfile({
    Key? key,
    required this.custCode,
  }) : super(key: key);

  @override
  State<uploadProfile> createState() => _uploadProfileState();
}

class _uploadProfileState extends State<uploadProfile> {
  File? image;
  final ImagePicker _picker = ImagePicker();

  Future getImage(source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {
        //
      });
    }
  }

  Future uploadImage(image) async {
    if (image != null) {
      setState(() {});

var profileUpload = uploadImage(widget.custCode, image!);
      // ignore: unrelated_type_equality_checks
      if (profileUpload != false) {
        setState(() {
          print(image);
        });
      } else {
        setState(() {
          print(image);
        });
      }

    } else {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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
                    borderRadius: BorderRadius.circular(8.0),
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('Upload Customer face photo'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        ElevatedButton(
                            onPressed: () {
                              uploadImage(image!);
                            },
                            child: const Text('Upload'))
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('Upload Customer face photo'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
    );
  }
}
 */