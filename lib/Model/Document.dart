import 'dart:convert';

Document documentFromJson(String str) => Document.fromJson(json.decode(str));

String documentToJson(Document data) => json.encode(data.toJson());

class Document {
  Document({
    this.userId,
    this.documentName,
    this.documentFile,
    this.date,
  });

  String userId;
  String documentName;
  String documentFile;
  DateTime date;

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    userId: json["user_id"],
    documentName: json["document_name"],
    documentFile: json["document_file"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "document_name": documentName,
    "document_file": documentFile,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
  };
}