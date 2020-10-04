import 'dart:convert';

import 'package:flutter/cupertino.dart';

Document documentFromJson(String str) => Document.fromJson(json.decode(str));

String documentToJson(Document data) => json.encode(data.toJson());

class Document {
  Document({
    this.userId,
    this.documentName,
    this.documentFile,
    this.document_ext,
    this.date,
    this.selected
  });

  String userId;
  String documentName;
  String documentFile;
  String document_ext;
  DateTime date;
  bool selected;

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    userId: json["user_id"],
    documentName: json["document_name"],
    documentFile: json["document_file"],
    document_ext: json["document_ext"],
    date: DateTime.parse(json["date"]),
    selected: false
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "document_name": documentName,
    "document_file": documentFile,
    "document_ext" : document_ext,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
  };
}