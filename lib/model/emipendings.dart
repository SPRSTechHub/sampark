import 'dart:convert';

////////////////////////////// Emi Data /////////////////////////////////
List<Pendingloanemi> pendingloanemiFromJson(String str) =>
    List<Pendingloanemi>.from(
        json.decode(str).map((x) => Pendingloanemi.fromJson(x)));

String pendingloanemiToJson(List<Pendingloanemi> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Pendingloanemi {
  Pendingloanemi({
    required this.loanNo,
    required this.emiCode,
    required this.date,
    required this.emiAmount,
  });

  String loanNo;
  String emiCode;
  String date;
  String emiAmount;

  factory Pendingloanemi.fromJson(Map<String, dynamic> json) => Pendingloanemi(
        loanNo: json["emi_code"],
        emiCode: json["emi_code"],
        date: json["date"],
        emiAmount: json["emi_amount"],
      );

  Map<String, dynamic> toJson() => {
        "loan_no": loanNo,
        "emi_code": emiCode,
        "date": date,
        "emi_amount": emiAmount,
      };
}

////////////////////////////// Loan Data /////////////////////////////////
List<Pendingloandata> pendingloandataFromJson(String str) =>
    List<Pendingloandata>.from(
        json.decode(str).map((x) => Pendingloandata.fromJson(x)));

String pendingloandataToJson(List<Pendingloandata> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Pendingloandata {
  Pendingloandata({
    required this.custCode,
    required this.loanNo,
    required this.loanDate,
    this.loanAmnt,
    this.emiAmnt,
    required this.tenure,
    this.name,
    required this.mobile,
    this.pendingEmiCount,
  });

  String custCode;
  String loanNo;
  String loanDate;
  String? loanAmnt;
  String? emiAmnt;
  String tenure;
  String? name;
  String? mobile;
  int? pendingEmiCount;

  factory Pendingloandata.fromJson(Map<String, dynamic> json) =>
      Pendingloandata(
        custCode: json["cust_code"],
        loanNo: json["loan_no"],
        loanDate: json["loan_date"],
        loanAmnt: json["loan_amnt"],
        emiAmnt: json["emi_amnt"],
        tenure: json["tenure"],
        name: json["name"],
        mobile: json["mobile"],
        pendingEmiCount: json["pending_emi_count"],
      );

  Map<String, dynamic> toJson() => {
        "cust_code": custCode,
        "loan_no": loanNo,
        "loan_date": loanDate,
        "loan_amnt": loanAmnt,
        "emi_amnt": emiAmnt,
        "tenure": tenure,
        "name": name,
        "mobile": mobile,
        "pending_emi_count": pendingEmiCount,
      };
}
