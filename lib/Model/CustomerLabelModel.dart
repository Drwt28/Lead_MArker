// To parse this JSON data, do
//
//     final customerLabelModel = customerLabelModelFromJson(jsonString);

import 'dart:convert';

CustomerLabelModel customerLabelModelFromJson(String str) => CustomerLabelModel.fromJson(json.decode(str));

String customerLabelModelToJson(CustomerLabelModel data) => json.encode(data.toJson());

class CustomerLabelModel {
  CustomerLabelModel({
    this.status,
    this.labelList,
    this.totalRows,
    this.message,
  });

  bool status;
  List<LabelList> labelList;
  int totalRows;
  String message;

  factory CustomerLabelModel.fromJson(Map<String, dynamic> json) => CustomerLabelModel(
    status: json["status"],
    labelList: List<LabelList>.from(json["label_list"].map((x) => LabelList.fromJson(x))),
    totalRows: json["total_rows"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "label_list": List<dynamic>.from(labelList.map((x) => x.toJson())),
    "total_rows": totalRows,
    "message": message,
  };
}

class LabelList {
  LabelList({
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

  factory LabelList.fromJson(Map<String, dynamic> json) => LabelList(
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
