// To parse this JSON data, do
//
//     final customerLabelModel = customerLabelModelFromJson(jsonString);

import 'dart:convert';

CustomerLabelModel customerLabelModelFromJson(String str) => CustomerLabelModel.fromJson(json.decode(str));

String customerLabelModelToJson(CustomerLabelModel data) => json.encode(data.toJson());

class CustomerLabelModel {
  CustomerLabelModel({
    this.status,
    this.cutstomers,
    this.totalCustomers,
    this.message,
  });

  bool status;
  List<Cutstomer> cutstomers;
  int totalCustomers;
  String message;

  factory CustomerLabelModel.fromJson(Map<String, dynamic> json) => CustomerLabelModel(
    status: json["status"],
    cutstomers: List<Cutstomer>.from(json["cutstomers"].map((x) => Cutstomer.fromJson(x))),
    totalCustomers: json["totalCustomers"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "cutstomers": List<dynamic>.from(cutstomers.map((x) => x.toJson())),
    "totalCustomers": totalCustomers,
    "message": message,
  };
}

class Cutstomer {
  Cutstomer({
    this.id,
    this.cusLeadId,
    this.userId,
    this.labelId,
    this.labelName,
    this.color,
    this.dateAdded,
    this.date,
  });

  String id;
  String cusLeadId;
  String userId;
  String labelId;
  String labelName;
  String color;
  DateTime dateAdded;
  DateTime date;

  factory Cutstomer.fromJson(Map<String, dynamic> json) => Cutstomer(
    id: json["id"],
    cusLeadId: json["cus_lead_id"],
    userId: json["userId"],
    labelId: json["label_id"],
    labelName: json["label_name"],
    color: json["color"],
    dateAdded: DateTime.parse(json["date_added"]),
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cus_lead_id": cusLeadId,
    "userId": userId,
    "label_id": labelId,
    "label_name": labelName,
    "color": color,
    "date_added": dateAdded.toIso8601String(),
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
  };
}
