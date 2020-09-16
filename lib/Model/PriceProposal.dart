// To parse this JSON data, do
//
//     final priceProposal = priceProposalFromJson(jsonString);

import 'dart:convert';

PriceProposal priceProposalFromJson(String str) => PriceProposal.fromJson(json.decode(str));

String priceProposalToJson(PriceProposal data) => json.encode(data.toJson());

class PriceProposal {
  PriceProposal({
    this.id,
    this.custLeadId,
    this.custLeadName,
    this.description,
    this.quantity,
    this.amount,
    this.invoiceImg,
    this.date,
    this.currentDatetime,
  });

  String id;
  String custLeadId;
  String custLeadName;
  String description;
  String quantity;
  String amount;
  String invoiceImg;
  DateTime date;
  DateTime currentDatetime;

  factory PriceProposal.fromJson(Map<String, dynamic> json) => PriceProposal(
    id: json["id"],
    custLeadId: json["cust_lead_id"],
    custLeadName: json["cust_lead_name"],
    description: json["description"],
    quantity: json["quantity"],
    amount: json["amount"],
    invoiceImg: json["invoice_img"],
    date: DateTime.parse(json["date"]),
    currentDatetime: DateTime.parse(json["current_datetime"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cust_lead_id": custLeadId,
    "cust_lead_name": custLeadName,
    "description": description,
    "quantity": quantity,
    "amount": amount,
    "invoice_img": invoiceImg,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "current_datetime": currentDatetime.toIso8601String(),
  };
}
