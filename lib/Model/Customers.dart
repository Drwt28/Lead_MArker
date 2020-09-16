/// id : "27"
/// user_id : "151"
/// name : "sneha"
/// phone_no : ""
/// company : "gritfusio"
/// email : "it@gmail.com,ut@gmail.com"
/// address : "dfdgdgg"
/// event : "qwert"
/// date : "2020-08-21"
/// status : "show"
/// added_date : "2020-08-20 22:17:01"
/// user_type : "customer"

class Customers {
  String _id;
  String _userId;
  String _name;
  String _phoneNo;
  String _company;
  String _email;
  String _address;
  String _event;
  String _date;
  String _status;
  String _addedDate;
  String _userType;

  String get id => _id;
  String get userId => _userId;
  String get name => _name;
  String get phoneNo => _phoneNo;
  String get company => _company;
  String get email => _email;
  String get address => _address;
  String get event => _event;
  String get date => _date;
  String get status => _status;
  String get addedDate => _addedDate;
  String get userType => _userType;

  Customers({
      String id,
      String userId,
      String name,
      String phoneNo,
      String company,
      String email,
      String address,
      String event,
      String date,
      String status,
      String addedDate,
      String userType}){
    _id = id;
    _userId = userId;
    _name = name;
    _phoneNo = phoneNo;
    _company = company;
    _email = email;
    _address = address;
    _event = event;
    _date = date;
    _status = status;
    _addedDate = addedDate;
    _userType = userType;
}

  Customers.fromJson(dynamic json) {
    _id = json["id"];
    _userId = json["userId"];
    _name = json["name"];
    _phoneNo = json["phoneNo"];
    _company = json["company"];
    _email = json["email"];
    _address = json["address"];
    _event = json["event"];
    _date = json["date"];
    _status = json["status"];
    _addedDate = json["addedDate"];
    _userType = json["userType"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["userId"] = _userId;
    map["name"] = _name;
    map["phoneNo"] = _phoneNo;
    map["company"] = _company;
    map["email"] = _email;
    map["address"] = _address;
    map["event"] = _event;
    map["date"] = _date;
    map["status"] = _status;
    map["addedDate"] = _addedDate;
    map["userType"] = _userType;
    return map;
  }

}