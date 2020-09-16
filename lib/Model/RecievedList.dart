
class RecievedList {
  RecievedList({
    this.status,
    this.details,
    this.approvedList,
    this.message,
  });

  bool status;
  List<ApprovedList> details;
  List<ApprovedList> approvedList;
  String message;

  factory RecievedList.fromJson(Map<String, dynamic> json) => RecievedList(
    status: json["status"],
    details: List<ApprovedList>.from(json["details"].map((x) => ApprovedList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "details": List<dynamic>.from(details.map((x) => x.toJson())),
    "approved_list": List<dynamic>.from(approvedList.map((x) => x.toJson())),
    "message": message,
  };
}

class ApprovedList {
  ApprovedList({
    this.id,
    this.shareBy,
    this.shareTo,
    this.cusLeadId,
    this.receiveStatus,
    this.type,
    this.date,
  });

  String id;
  String shareBy;
  String shareTo;
  String cusLeadId;
  String receiveStatus;
  String type;
  DateTime date;

  factory ApprovedList.fromJson(Map<String, dynamic> json) => ApprovedList(
    id: json["id"],
    shareBy: json["share_by"],
    shareTo: json["share_to"],
    cusLeadId: json["cus_lead_id"],
    receiveStatus: json["receive_status"],
    type: json["type"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "share_by": shareBy,
    "share_to": shareTo,
    "cus_lead_id": cusLeadId,
    "receive_status": receiveStatus,
    "type": type,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
  };
}
