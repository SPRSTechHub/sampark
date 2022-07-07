import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sampark/model/allcustomers.dart';
import 'package:sampark/model/customer.dart';

jsonString(Map<String, String> map) {}
Map<String, String> headers = {
  "Content-type": "application/x-www-form-urlencoded"
};

Future getAccess(String? token) async {
  var jsonBody = {'token': token ?? 'null', 'action': 'authchk'};
  final response = await http.post(
      Uri.parse('https://play.liveipl.online/apifile/authchecker/'),
      headers: headers,
      body: jsonBody);
  if (response.statusCode == 200) {
    var rsp = jsonDecode(response.body);
    return rsp;
  } else {
    return null;
  }
}

Future<List<AllCustomersData>?> getAllCustomers() async {
  var jsonBody = {'action': 'getdata'};

  var client = http.Client();
  var uri = Uri.parse('https://play.liveipl.online/apifile/getAllCustomers/');
  final response = await client.post(uri, headers: headers, body: jsonBody);
  if (response.statusCode == 200) {
    var rsp = jsonDecode(response.body);
    if (rsp['status'] == 1) {
      return AllCustomersDataFromJson(jsonEncode(rsp['data']));
    } else {
      return null;
    }
  }
  return null;
}

Future<List<Customer>?> getCustomers(String mobile) async {
  var jsonBody = {'mobile': mobile, 'action': 'getdata'};

  var client = http.Client();
  var uri = Uri.parse('https://play.liveipl.online/apifile/getCustomer/');
  final response = await client.post(uri, headers: headers, body: jsonBody);
  if (response.statusCode == 200) {
    var rsp = jsonDecode(response.body);
    if (rsp['status'] == 1) {
      return customerFromJson(jsonEncode(rsp['data']));
    } else {
      return null;
    }
  }
  return null;
}

Future getCust(String mobile) async {
  var jsonBody = {'mobile': mobile, 'action': 'checkdata'};
  final response = await http.post(
      Uri.parse('https://play.liveipl.online/apifile/chkCustomer/'),
      headers: headers,
      body: jsonBody);
  if (response.statusCode == 200) {
    var rsp = jsonDecode(response.body);
    return rsp;
  } else {
    return null;
  }
}

Future addLoanFunc(String mobile, String custCode, String emiAmnt,
    String loanDate, String loanAmnt, String purpose, String tenure) async {
  var jsonBody = {
    'mobile': mobile,
    'cust_code': custCode,
    'emi_amnt': emiAmnt,
    'loan_date': loanDate,
    'loan_amnt': loanAmnt,
    'purpose': purpose,
    'tenure': tenure,
    'action': 'add_new_loan'
  };
  final response = await http.post(
      Uri.parse('https://play.liveipl.online/apifile/add_cust_loan/'),
      headers: headers,
      body: jsonBody);
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    return null;
  }
}

Future uploadImage(String ccode, File? image) async {
  var stream = http.ByteStream(image!.openRead());
  stream.cast();
  var req = http.MultipartRequest(
      "POST", Uri.parse('https://play.liveipl.online/apifile/add_cust_image'));
  req.headers["Content-type"] = "application/x-www-form-urlencoded";
  req.fields["id"] = ccode; //ccode;
  req.fields["action"] = 'avatarUploader';
  var pic = await http.MultipartFile.fromPath('image', image.path);
  req.files.add(pic);

  var response = await req.send();
  var responsed = await http.Response.fromStream(response);
  final responseData = jsonDecode(responsed.body);

  if (response.statusCode == 200) {
    return responseData;
  } else {
    return false;
  }
}

Future<dynamic> uploadDocs(
    String ccode, String docno, String? type, File? image) async {
  var stream = http.ByteStream(image!.openRead());
  stream.cast();
  var req = http.MultipartRequest(
      "POST", Uri.parse('https://play.liveipl.online/apifile/add_cust_docs'));
  req.headers["Content-type"] = "application/x-www-form-urlencoded";
  req.fields["cust_code"] = ccode;
  req.fields["doc_type"] = type!;
  req.fields["doc_no"] = docno;
  req.fields["action"] = 'docUploader';
  var pic = await http.MultipartFile.fromPath('image', image.path);
  req.files.add(pic);

  var response = await req.send();
  var responsed = await http.Response.fromStream(response);

  if (response.statusCode == 200) {
    final responseData = jsonDecode(responsed.body);
    return responseData;
  } else {
    return false;
  }
}

Future customerRegistration(
    fName, lName, mobile, altMob, gender, address, dob) async {
  var jsonBody = {
    'f_name': fName,
    'l_name': lName,
    'mobile': mobile,
    'alt_mob': altMob,
    'address': address,
    'gender': gender,
    'dob': dob,
    'action': 'registration'
  };

  final response = await http.post(
      Uri.parse('https://play.liveipl.online/apifile/add_cust/'),
      headers: headers,
      body: jsonBody);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    return false;
  }
}

// get Customer Cibil Score //

Future getCbil(String mobile, String dataval) async {
  var jsonBody = {'checkby': mobile, 'dataval': dataval, 'action': 'chkcbil'};
  final response = await http.post(
      Uri.parse('https://play.liveipl.online/apifile/fetch_cibil/'),
      headers: headers,
      body: jsonBody);
  if (response.statusCode == 200) {
    var rsp = jsonDecode(response.body);
  //  print(rsp);
    return rsp;
  } else {
    return null;
  }
}
