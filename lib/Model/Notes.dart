class Notes {
  Notes({
    this.id,
    this.custLeadId,
    this.note,
    this.date,
  });

  String id;
  String custLeadId;
  String note;
  DateTime date;

  factory Notes.fromJson(Map<String, dynamic> json) => Notes(
    id: json["id"],
    custLeadId: json["cust_lead_id"],
    note: json["note"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cust_lead_id": custLeadId,
    "note": note,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
  };
}