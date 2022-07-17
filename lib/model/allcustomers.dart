// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

List<AllCustomersData> AllCustomersDataFromJson(String str) =>
    List<AllCustomersData>.from(
        json.decode(str).map((x) => AllCustomersData.fromJson(x)));

String AllCustomersDataToJson(List<AllCustomersData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllCustomersData {
  AllCustomersData({
    required this.name,
    required this.mobile,
    required this.imgLink,
    this.loanAmnt,
    this.emiAmnt,
    this.cstatus,
  });

  String name;
  String? mobile;
  String imgLink;
  String? loanAmnt;
  String? emiAmnt;
  String? cstatus;

  factory AllCustomersData.fromJson(Map<String, dynamic> json) =>
      AllCustomersData(
        name: json["Name"],
        mobile: json["mobile"],
        imgLink: json["img_link"],
        loanAmnt: json["loanAmnt"],
        emiAmnt: json["emiAmnt"],
        cstatus: json["cstatus"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "mobile": mobile,
        "img_link": imgLink,
        "loanAmnt": loanAmnt,
        "emiAmnt": emiAmnt,
        "cstatus": cstatus,
      };
}
