// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
    this.userTasks,
    this.userList,
    this.customer,
    this.leads,
    this.subUsers,
    this.leadsAddedLabel,
    this.customerAddedLabels,
    this.message,
  });


  List<SubUser> userList;
  List<Customer> customer;
  List<Customer> leads;
  List<SubUser> subUsers;
  List<AddedLabel> leadsAddedLabel;
  List<AddedLabel> customerAddedLabels;
  List<Task> userTasks;
  String message;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(

    userTasks: List<Task>.from(json["users_task"].map((x) => Task.fromJson(x))),
    userList: !(json["userList"] is List)?[]:List<SubUser>.from(json["userList"].map((x) => SubUser.fromJson(x))),
    customer: !(json["customer"] is List)?[]:List<Customer>.from(json["customer"].map((x) => Customer.fromJson(x))),
    leads: List<Customer>.from(json["leads"].map((x) => Customer.fromJson(x))),
    subUsers:!(json["sub_users"] is List)?[]: List<SubUser>.from(json["sub_users"].map((x) => SubUser.fromJson(x))),
    leadsAddedLabel: !(json["customer_added_labels"] is List)?[]: List<AddedLabel>.from(json["leads_added_label"].map((x) => AddedLabel.fromJson(x))),
    customerAddedLabels: (json["customer_added_labels"] is bool)?[]:List<AddedLabel>.from(json["customer_added_labels"].map((x) => AddedLabel.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {

    "users_task":List<dynamic>.from(userTasks.map((e) => e.toJson())),
    "userList": List<dynamic>.from(userList.map((x) => x.toJson())),
    "customer": List<dynamic>.from(customer.map((x) => x.toJson())),
    "leads": List<dynamic>.from(leads.map((x) => x.toJson())),
    "sub_users": List<dynamic>.from(subUsers.map((x) => x.toJson())),
    "leads_added_label": List<dynamic>.from(leadsAddedLabel.map((x) => x.toJson())),
    "customer_added_labels": List<dynamic>.from(customerAddedLabels.map((x) => x.toJson())),
    "message": message,
  };
}

class Customer {
  Customer({
    this.id,
    this.userId,
    this.name,
    this.phoneNo,
    this.company,
    this.email,
    this.address,
    this.event,
    this.date,
    this.status,
    this.addedDate,
    this.userType,
  });

  bool expanded = false;
  String id;
  String userId;
  String name;
  List phoneNo;
  String company;
  List email;
  String address;
  String event;
  DateTime date;
  String status;
  DateTime addedDate;
  String userType;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"],
    userId: json["user_id"],
    name: json["name"],
    phoneNo: json["phone_no"],
    company: json["company"],
    email: json["email"],
    address: json["address"],
    event: json["event"],
    date: DateTime.parse(json["date"]),
    status: json["status"],
    addedDate: DateTime.parse(json["added_date"]),
    userType: json["user_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "phone_no": phoneNo,
    "company": company,
    "email": email,
    "address": address,
    "event": event,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "status": status,
    "added_date": addedDate.toIso8601String(),
    "user_type": userType,
  };
}

class AddedLabel {


  bool _selected = false;
  bool get isSelected => _selected??false;

  set selected(bool value) {
    _selected = value;
  }
  AddedLabel({
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
  String dateAdded;
  String date;

  factory AddedLabel.fromJson(Map<String, dynamic> json) => AddedLabel(
    id: json["id"],
    cusLeadId: json["cus_lead_id"]??'',
    userId: json["userId"]??'',
    labelId: json["label_id"]??'',
    labelName: json["label_name"]??'',
    color: json["color"]??'',
    dateAdded: json["date_added"].toString(),
    date: json["date"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cus_lead_id": cusLeadId,
    "userId": userId,
    "label_id": labelId,
    "label_name": labelName,
    "color": color,
    "date_added": dateAdded,
    "date": date,
  };
}

class SubUser {
  SubUser({
    this.id,
    this.username,
    this.emailId,
    this.phoneNo,
    this.password,
    this.createdAt,
    this.createdBy,
    this.userType,
    this.plainPassword,
    this.role,
  });

  String id;
  String username;
  String emailId;
  String phoneNo;
  String password;
  DateTime createdAt;
  String createdBy;
  String userType;
  String plainPassword;
  String role;

  factory SubUser.fromJson(Map<String, dynamic> json) => SubUser(
    id: json["id"],
    username: json["username"],
    emailId: json["email_id"],
    phoneNo: json["phone_no"],
    password: json["password"],
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    userType: json["user_type"],
    plainPassword: json["plain_password"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email_id": emailId,
    "phone_no": phoneNo,
    "password": password,
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "user_type": userType,
    "plain_password": plainPassword,
    "role": role,
  };
}
class Task {
  Task({
    this.cust_lead_id,
    this.id,
    this.userId,
    this.remainderDate,
    this.description,
    this.date,
  });

  String id,cust_lead_id;
  String userId;
  DateTime remainderDate;
  String description;
  DateTime date;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["id"],
    cust_lead_id: json["cust_lead_id"],
    userId: json["user_id"],
    remainderDate: DateTime.parse(json["remainder_date"]),
    description: json["description"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cust_lead_id": cust_lead_id,
    "user_id": userId,
    "remainder_date": remainderDate.toIso8601String(),
    "description": description,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
  };
}
