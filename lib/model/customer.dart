import 'dart:convert';

List<Customer> customerFromJson(String str) =>
    List<Customer>.from(json.decode(str).map((x) => Customer.fromJson(x)));

String customerToJson(List<Customer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Customer {
  Customer({
    required this.id,
    required this.custCode,
    required this.fName,
    this.lName,
    required this.mobile,
    this.altMob,
    this.dob,
    this.gender,
    this.address,
    required this.status,
    this.date,
    required this.img,
  });

  String id;
  String custCode;
  String fName;
  String? lName;
  String mobile;
  String? altMob;
  String? dob;
  String? gender;
  String? address;
  String status;
  String? date;
  String img;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"],
    custCode: json["cust_code"],
    fName: json["f_name"],
    lName: json["l_name"],
    mobile: json["mobile"],
    altMob: json["alt_mob"],
    dob: json["dob"],
    gender: json["gender"],
    address: json["address"],
    status: json["status"],
    date: json["date"],
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cust_code": custCode,
    "f_name": fName,
    "l_name": lName,
    "mobile": mobile,
    "alt_mob": altMob,
    "dob": dob,
    "gender": gender,
    "address": address,
    "status": status,
    "date": date,
    "img": img,
  };
}