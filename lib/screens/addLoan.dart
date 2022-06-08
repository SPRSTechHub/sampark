import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sampark/app.dart';
import 'package:sampark/utils/api.dart';
import 'package:easy_debounce/easy_debounce.dart';

class AddLoan extends StatefulWidget {
  const AddLoan({Key? key}) : super(key: key);

  @override
  State<AddLoan> createState() => _AddLoanState();
}

class _AddLoanState extends State<AddLoan> {
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> formData;
// Set up Form inputs //
  String selectTunnure = "";
  String selectPurpose = "";

  final mobile_Controller = TextEditingController();
  final cust_code_Controller = TextEditingController();
  final loan_amnt_Controller = TextEditingController();
  final emi_amnt_Controller = TextEditingController();
  final purpose_Controller = TextEditingController();
  final tenure_Controller = TextEditingController();

  @override
  void dispose() {
    mobile_Controller.dispose();
    cust_code_Controller.dispose();
    loan_amnt_Controller.dispose();
    emi_amnt_Controller.dispose();
    //
    tenure_Controller.dispose();
purpose_Controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AddLoan()));
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color(0xFF0704EC),
                            child: IconButton(
                              icon: const Icon(
                                Icons.account_balance_outlined,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Home(
                                            title: 'Add New', page: 3)));
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text('Add Customer',
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const Home(title: 'Add New', page: 3)));
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color(0xFFFF0000),
                            child: IconButton(
                              icon: const Icon(
                                Icons.card_travel_rounded,
                                color: Colors.black,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(
                            height: 5,
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
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.orange,
                            child: IconButton(
                              icon: const Icon(
                                Icons.attach_file_rounded,
                                color: Colors.black,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text('Add Docs',
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onChanged: (value) async {
                            if (value.isEmpty || value.length != 10) {
                            } else {
                              var response = await getCust(value);
                              if (response['data'] != null) {
                                cust_code_Controller.text =
                                    response['data']['cust_code'];
                              } else {
                                cust_code_Controller.text = '';
                              }
                            }
                          },
                          obscureText: false,
                          decoration: CommonStyle.textFieldStyle(
                            labelTextStr: "Customer Mobile",
                            hintTextStr: "10 digit mobile number",
                            icon: const Icon(
                              Icons.phone_android_sharp,
                              color: Color(0xFFEBB818),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.phone,
                          controller: mobile_Controller,
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
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          onChanged: (_) => EasyDebounce.debounce(
                            'cust_code',
                            const Duration(milliseconds: 2000),
                            () => setState(() {}),
                          ),
                          obscureText: false,
                          readOnly: true,
                          decoration: CommonStyle.textFieldStyle(
                            labelTextStr: "Customer Code",
                            hintTextStr: "Enter Customer code",
                            icon: const Icon(
                              Icons.person,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.start,
                          controller: cust_code_Controller,
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
                        child: TextFormField(
                          onChanged: (_) => EasyDebounce.debounce(
                            'loan_txt',
                            const Duration(milliseconds: 2000),
                            () => setState(() {}),
                          ),
                          obscureText: false,
                          decoration: CommonStyle.textFieldStyle(
                            labelTextStr: "Principle Amount",
                            hintTextStr: "Enter Loan amount taken",
                            icon: const Icon(
                              Icons.person,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.start,
                          controller: loan_amnt_Controller,
                          keyboardType: TextInputType.number,
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 0),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                          onChanged: (_) => EasyDebounce.debounce(
                            'loan_txt',
                            const Duration(milliseconds: 2000),
                            () => setState(() {}),
                          ),
                          obscureText: false,
                          decoration: CommonStyle.textFieldStyle(
                            labelTextStr: "Tennure",
                            hintTextStr: "Set Total Weeks",
                            icon: const Icon(
                              Icons.calendar_view_day_outlined,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.start,
                          controller: tenure_Controller,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length !=2) {
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 0),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)),
                            child: TextFormField(
                          onChanged: (_) => EasyDebounce.debounce(
                            'loan_txt',
                            const Duration(milliseconds: 2000),
                            () => setState(() {}),
                          ),
                          obscureText: false,
                          decoration: CommonStyle.textFieldStyle(
                            labelTextStr: "Purpose",
                            hintTextStr: "Enter Reason for Loan",
                            icon: const Icon(
                              Icons.expand_circle_down,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.start,
                          controller: purpose_Controller,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length >=12) {
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
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onChanged: (_) => EasyDebounce.debounce(
                            'emi_amnt',
                            const Duration(milliseconds: 2000),
                            () => setState(() {}),
                          ),
                          obscureText: false,
                          decoration: CommonStyle.textFieldStyle(
                            labelTextStr: "Emi Amount",
                            icon: const Icon(
                              Icons.phone_android_sharp,
                              color: Color(0xFFEBB818),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.number,
                          controller: emi_amnt_Controller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Emi Amount';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                // showSpinner = true;
                              });

                              var mobile = mobile_Controller.text;
                              var cust_code = cust_code_Controller.text;
                              var emi_amnt = emi_amnt_Controller.text;
                              var loan_amnt = loan_amnt_Controller.text;
                               var purpose = purpose_Controller.text;
                              var tenure = tenure_Controller.text;
                             // var purpose = selectPurpose;
                            //  var tenure = selectTunnure;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  action: SnackBarAction(
                                    label: 'Close',
                                    onPressed: () {
                                      // Code to execute.
                                    },
                                  ),
                                  content: const Text('Processing...'),
                                  duration: const Duration(milliseconds: 1500),
                                  width: 280.0, // Width of the SnackBar.
                                  padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        8.0, // Inner padding for SnackBar content.
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                ),
                              );
                              var response = await addLoanFunc(
                                  mobile,
                                  cust_code,
                                  emi_amnt,
                                  loan_amnt,
                                  purpose,
                                  tenure);
                              if (response['status'] == 1) {
                                setState(() {
                                  showSpinner = false;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      action: SnackBarAction(
                                        label: 'Close',
                                        onPressed: () {
                                          // Code to execute.
                                        },
                                      ),
                                      content: Text(response['msg'] +
                                          'Ref No.:' +
                                          response['lcode']),
                                      duration:
                                          const Duration(milliseconds: 1500),
                                      width: 280.0, // Width of the SnackBar.
                                      padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            8.0, // Inner padding for SnackBar content.
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                    ),
                                  );
                                });
                              } else if (response['status'] == 0) {
                                setState(() {
                                  showSpinner = false;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(response['msg'])),
                                  );
                                });
                              } else {
                                showSpinner = false;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Server Error')),
                                );
                                throw Exception('Server Error');
                              }
                            }
                          },
                          child: const Text('Next'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommonStyle {
  static InputDecoration textFieldStyle(
      {String labelTextStr = "", String hintTextStr = "", Icon? icon}) {
    var myFocusNode = FocusNode();
    return InputDecoration(
      filled: true,
      fillColor: Colors.blue,
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
