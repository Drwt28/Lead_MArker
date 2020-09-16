import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:flutter_olx/Model/BusinessDetails.dart';
import 'package:flutter_olx/Model/Customers.dart';
import 'package:flutter_olx/Model/UserData.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/Label.dart';
import '../Model/Lead.dart';
import '../Model/Team.dart';

class User with ChangeNotifier {

  final ENDPOINT = 'http://flutter_olx.appnitro.co/api';


  List<Lead> _leads = List();
  List<Customer> _customers = List();
  List<Label> _labels = [];
  List<Team> _teams = List();
  List<Label> get labels => _labels;
  List<Lead> get leads => _leads;
  String _id, _userName, _mailId, _phoneNo, _business_details, _tokken;
  BusinessDetails _businessDetails =
  BusinessDetails('', '', '', '', '', '', '');




  User() {
    try {
      getUser();
    } catch (e) {
      print(e);
    }
  }
  //methods

  List<Team> get teams => _teams;
  BusinessDetails get businessDetails => _businessDetails;
  getTeamList() async {
    try {
      var url =
          '${ENDPOINT}/user-added-team-name-list/${this.id}';
      var apikey = 'APIKEY@TEST';
      var response = await http
          .get(url, headers: {"x-api-key": apikey, 'Auth': this._tokken});

      var data = JsonDecoder().convert(response.body);

      print(data);
      var list = data['team_list'];
      var teams = List<Team>();
      for (var l in list) {
        teams.add(Team.fromJson(l));
      }
      _teams = teams;
      notifyListeners();
      return _teams;
    } catch (e) {
      print('error');
      print(e.toString());
    }
  }



  Future<bool> addTeam(String name) async {
    try {
      var url = '${ENDPOINT}/user-add-team';
      var apikey = 'APIKEY@TEST';
      var response = await http.post(url,
          headers: {"x-api-key": apikey, 'Auth': this._tokken},
          body: {'user_id': this._id, 'team_name': name});

      var data = JsonDecoder().convert(response.body);
      if (data['status']) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<BusinessDetails> getBusinessDetails() async {
    var url =
        '${ENDPOINT}/Business_Details/get-user/${this.id}';
    var apikey = 'APIKEY@TEST';
    var response = await http.get(
      url,
      headers: {"x-api-key": apikey, 'Auth': this._tokken},
    );

    var data = JsonDecoder().convert(response.body);
    try {
      if (data['status']) {
        var details = BusinessDetails.fromJson(data);
        this._businessDetails = details;
        notifyListeners();
        return details;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  setbusinessDetails(BusinessDetails businessDetails) async {
    var url =
        '${ENDPOINT}/Business_Details/enter-business-info/${this.id}';
    var apikey = 'APIKEY@TEST';
    var response = await http.post(url, headers: {
      "x-api-key": apikey,
      'Auth': this._tokken
    }, body: {
      'bussiness_name': businessDetails.name,
      'bussiness_description': businessDetails.description,
      'bussiness_address': businessDetails.address,
      'bussiness_timing': businessDetails.timing,
      'bussiness_contactno': businessDetails.contactno,
      'bussiness_email': businessDetails.email,
    });

    var data = JsonDecoder().convert(response.body);
    print(data);
    try {
      if (data['status']) {
        this._businessDetails = businessDetails;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
    print(data);
  }






  Future<List<Label>> getLabelList() async {
    print(this.id);
    try {
      var url = '${ENDPOINT}/Labels/getlabel/${this.id}';
      var apikey = 'APIKEY@TEST';
      var response = await http
          .get(url, headers: {"x-api-key": apikey, 'Auth': this._tokken});

      var data = JsonDecoder().convert(response.body);

      var temp = List();
      print(data);
      if (data['status']) {
        var list = data['label_list'];
        for (var l in list) {
          temp.add(Label.fromJson(l));
        }
      }
      _labels = temp;
      notifyListeners();
      return _labels;
    } catch (e) {
      return List<Label>();
    }
  }



  Future<List<Label>> insertLabel(Label label) async {
    print(this.id);
    var url = '${ENDPOINT}/Labels/insertLabel/${this.id}';

    var apikey = 'APIKEY@TEST';
    var response = await http.post(url, headers: {
      "x-api-key": apikey,
      'Auth': this._tokken
    }, body: {
      'label_name': label.text,
      'color': label.color,
    });

    var data = JsonDecoder().convert(response.body);
    print(data.toString());
    if (data['status']) {
      return await getLabelList();
    }
  }

  Future<List<Label>> deleteLabel(Label label) async {
    print(this.id);
    var url = '${ENDPOINT}/Labels/deletLabels';

    var apikey = 'APIKEY@TEST';
    var response = await http.post(url, headers: {
      "x-api-key": apikey,
      'Auth': this._tokken
    }, body: {
      'id': label.id,
    });
    var data = JsonDecoder().convert(response.body);
    print(data.toString());
    if (data['status']) {
      return await getLabelList();
    }
  }

  Future<String> insertLead(Lead lead) async {
    var url =
        '${ENDPOINT}/leads/enter-leads-info/${this.id}';
    var apikey = 'APIKEY@TEST';
    var response = await http.post(url, headers: {
      "x-api-key": apikey,
      'Auth': this._tokken
    }, body: {
      'name': lead.name,
      'phone_no': lead.phoneNo,
      'company': lead.company,
      'address': lead.address,
      'event': lead.event,
      'email': lead.email
    });

    var data;
    try {
      data = JsonDecoder().convert(response.body);
      print(data);
      var status = data['status'];
      if (status) {
        await getLeadList();
        return 'Lead Created Succesfully';
      } else {
        return 'Failed to create lead';
      }
    } catch (e) {
      print(data);
      return data.toString();
    }
  }

 static Future<void> saveUser(Response response) async {
    var pref = await SharedPreferences.getInstance();
    try {
      var data = (JsonDecoder().convert(response.body))['data'];
      print(data);
      await pref.setString('id', data['id']);
      await pref.setString('username', data['username']);
      await pref.setString('email_id', data['email_id']);
      await pref.setString('token', data['token']);
      await  pref.setString('phone_no', data['phone_no']);
      await  pref.setString('role', data['role']);

      return;
    } catch (e) {
      print(e.toString());
    return ;
    }
  }

    getUser() async {
      String loginUrl = '${ENDPOINT}/users/login';
      try {
        var res = await http.post(loginUrl,
            body: {'email_id': 'neha@gmail.com', 'password': '12345'});
        _tokken = JsonDecoder().convert(res.body)['data']['token'];
        var pref = await SharedPreferences.getInstance();
        this._id = pref.getString('id');
        this._userName = pref.getString('username');
        this._mailId = pref.getString('email_id');
        this._business_details = pref.getString('business_details');
        this._phoneNo = pref.getString('phone_no');
        this._leads = [];
        this._customers = [];
        this._labels = [];
        notifyListeners();
      } catch (e) {}

  //    return this;
    }

  Future<List<Label>> getCustomerLabel(id) async {
    var url =
        '${ENDPOINT}/leads_labels_added_details/get-list/$id';
    var apikey = 'APIKEY@TEST';
    var response = await http
        .get(url, headers: {"x-api-key": apikey, 'Auth': this._tokken});

    print(response.body);
    try {
      var label_List = List<Label>();
      var data = JsonDecoder().convert(response.body);
      if (data['status']) {
        var list = data['customer_added_lable_list'];
        for (var l in list) {
          label_List.add(Label.fromJson(l));
        }
      }
      return label_List;
    } catch (e) {
      return [];
    }
  }

  Future<List<Label>> getleadLabel(id) async {
    var url =
        '${ENDPOINT}/leads_labels_added_details/get-list/$id';
    var apikey = 'APIKEY@TEST';
    var response = await http
        .get(url, headers: {"x-api-key": apikey, 'Auth': this._tokken});

    print(response.body);
    try {
      var label_List = List<Label>();
      var data = JsonDecoder().convert(response.body);
      if (data['status']) {
        var list = data['customer_added_lable_list'];
        for (var l in list) {
          label_List.add(Label.fromJson(l));
        }
      }
      return label_List;
    } catch (e) {
      return [];
    }
  }

  Future<bool> deleteUser() async {
    try {
      var pref = await SharedPreferences.getInstance();

      var dec = await pref.clear();
      getUser();
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  //variables


  get phoneNo => _phoneNo;

  String get id => _id;

  get userName => _userName;

  get mailId => _mailId;

  get tokken => _tokken;

  get business_details => _business_details;

//

  Future<List<Customer>> getCustomers() async {
    try {
      var url =
          '${ENDPOINT}/Customer/getCustomerList/${this.id}';
      var apikey = 'APIKEY@TEST';
      var response = await http
          .get(url, headers: {"x-api-key": apikey, 'Auth': this._tokken});
      var data = JsonDecoder().convert(response.body);
      var customers = data['customer_list'];
      _customers = List();
      for (var customer in customers) {
        _customers.add(Customer.fromJson(customer));
      }
      notifyListeners();
    } catch (e) {}

    return _customers;
  }

  Future<List<Lead>> getLeadList() async {
    try {
      var url = '${ENDPOINT}/Leads/getLeadsList/${this.id}';
      var apikey = 'APIKEY@TEST';
      var response = await http
          .get(url, headers: {"x-api-key": apikey, 'Auth': this._tokken});
      var data = JsonDecoder().convert(response.body);
      var leads = data['lead_list'];
      var temp_list = List();
      for (var lead in leads) {
        var temp = Lead.fromJson(lead);
//        temp.labels = await getleadLabel(temp.id);
//        print(temp.labels.toString());
        temp_list.add(temp);
      }
      _leads = temp_list;
    } catch (e) {
      return _leads;
    }
    notifyListeners();
    return _leads;
  }

  List<Customer> get customers => _customers;

  Future<String> insertCustomer(Customer customer) async {
    var url =
        '${ENDPOINT}/customer/enter-customer-info/${this.id}';
    var apikey = 'APIKEY@TEST';
    var response = await http.post(url, headers: {
      "x-api-key": apikey,
      'Auth': this._tokken
    }, body: {
      'name': customer.name,
      'phone_no': customer.phoneNo,
      'company': customer.company,
      'address': customer.address,
      'event': customer.event,
      'email': customer.email
    });

    var data;
    try {
      data = JsonDecoder().convert(response.body);
      print(data);
      var status = data['status'];
      if (status) {
        _customers = await getCustomers();
        notifyListeners();
        return 'Customer Added Succesfully';
      } else {
        return 'Failed to create Customer';
      }
    } catch (e) {
      return data.toString();
    }
  }

  Future<List<Customer>> deleteCustomer(Customer customer) async {
    var url = '${ENDPOINT}/Customer/deleteCustomer';
    try {
      var apikey = 'APIKEY@TEST';
      var response = await http.post(url, headers: {
        "x-api-key": apikey,
        'Auth': this._tokken
      }, body: {
        'customer_id': customer.id,
      });
      var data = JsonDecoder().convert(response.body);
      print(customer.id);
      if (data['status']) {
        _customers.remove(customer);
        notifyListeners();
        return _customers;
      } else {
        notifyListeners();
        return _customers;
      }
    } catch (e) {
      return _customers;
    }
  }

  Future<bool> deleteLead(Lead lead) async {
    try {
      var url = '${ENDPOINT}/leads/delete-leads-details';
      var apikey = 'APIKEY@TEST';
      var response = await http.post(url, headers: {
        "x-api-key": apikey,
        'Auth': this._tokken
      }, body: {
        'leads_id': lead.id,
      });
      var data = JsonDecoder().convert(response.body);
      if (data['status']) {
        _leads.remove(lead);
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
