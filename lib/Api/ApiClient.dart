import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_olx/Model/CustomerLabelModel.dart';
import 'package:flutter_olx/Model/Document.dart';
import 'package:flutter_olx/Model/Notes.dart';
import 'package:flutter_olx/Model/PriceProposal.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_olx/Model/BusinessDetails.dart';
import 'package:flutter_olx/Model/Label.dart';
import 'package:flutter_olx/Model/RecievedList.dart';
import 'package:flutter_olx/Model/Team.dart';
import 'package:flutter_olx/Model/TeamMember.dart';
import 'package:flutter_olx/Model/UserData.dart';
import 'package:flutter_olx/Screens/HomeScreen/Task/AddTaskPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  String _id, _tokken;
  static final ENDPOINT = 'http://radient.appnitro.co/api';
  Map<String, String> header;

  Future<List<ApprovedList>> getRecievedList() async {
    var url = '$ENDPOINT/get-share-lead-customer';
    var response =
        await http.post(url, body: {'share_to': _id}, headers: header);
    RecievedList list =
        RecievedList.fromJson(JsonDecoder().convert(response.body));
    if (list.status) {
      return list.details;
    } else {
      return [];
    }
  }

  Future<List<ApprovedList>> getSentList() async {
    var url = '$ENDPOINT/get-share-by-lead-customer';
    var response =
        await http.post(url, body: {'share_by': _id}, headers: header);

    RecievedList list =
        RecievedList.fromJson(JsonDecoder().convert(response.body));
    if (list.status) {
      return list.details;
    } else {
      return [];
    }
  }

  approveLeadCust(String id) async {
    var url = '$ENDPOINT/approve-receive-lead-customer';

    var response = await http.post(url, headers: header, body: {'id': id});

    var data = JsonDecoder().convert(response.body);
  }

  shareWithTeam(TeamMember teamMember, Customer customer) async {
    var url = "$ENDPOINT/share-lead-customer";

    var response = await http.post(url,
        body: {
          'share_by[0]': _id,
          'share_to[0]': teamMember.subUserId,
          'cus_lead_id[0]': customer.id
        },
        headers: header);

    var data = JsonDecoder().convert(response.body);
    if (data['status']) {
      print(data);
    } else {
      print(data);
    }
  }

  addTask(Task task) async {
    var url = '$ENDPOINT/user-added-customer-lead-task';
    var response = await http.post(url,
        body: {
          'user_id': this._id,
          'remainder_date': task.remainderDate.toString(),
          'description': task.description,
          'cust_lead_id': task.cust_lead_id
        },
        headers: header);

    var data = JsonDecoder().convert(response.body);

    if (data['status']) {
      return true;
    } else {
      return false;
    }
  }

  setbusinessDetails(BusinessDetails businessDetails) async {
    var url = '${ENDPOINT}/Business_Details/enter-business-info/${this._id}';
    var apikey = 'APIKEY@TEST';
    var response = await http.post(url, headers: header, body: {
      'bussiness_name': businessDetails.name,
      'bussiness_description': businessDetails.description,
      'bussiness_address': businessDetails.address,
      'bussiness_timing': businessDetails.timing,
      'bussiness_contactno': businessDetails.contactno,
      'bussiness_email': businessDetails.email,
    });
  }

  Future<BusinessDetails> getBusinessDetails() async {
    var url = '${ENDPOINT}/Business_Details/get-user/${this._id}';
    var apikey = 'APIKEY@TEST';
    var response = await http.get(
      url,
      headers: header,
    );

    try {
      var data = JsonDecoder().convert(response.body);
      if (data['status']) {
        var details = BusinessDetails.fromJson(data);
        return details;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<TeamMember>> getTeamMembersList(String team_id) async {
    var url = "$ENDPOINT/team-member-list";
    var response =
        await http.post(url, headers: header, body: {'team_id': team_id});
    var data = JsonDecoder().convert(response.body);

    print(team_id);
    print(_tokken);
    print(data);
    if (data['status']) {
      List<TeamMember> members = List.castFrom(
          data['details'].map((e) => TeamMember.fromJson(e)).toList());
      return members;
    } else {
      return [];
    }
  }

  deleteTeam(String team_id) async {
    var url = "$ENDPOINT/delete-team";
    var response = await http.post(url, headers: header, body: {'id': team_id});
    var data = JsonDecoder().convert(response.body);

    print(team_id);
    print(data);
    if (data['status']) {
      return true;
    } else {
      return false;
    }
  }

  getTeamList() async {
    try {
      var url = '${ENDPOINT}/user-added-team-list';
      var response =
          await http.post(url, headers: header, body: {'userId': this._id});

      var data = JsonDecoder().convert(response.body);

      print(data);
      var list = data['team_list'];
      List<Team> teams = List();
      teams.clear();
      for (var l in list) {
        teams.add(Team.fromJson(l));
      }
      return teams;
    } catch (e) {
      print('error');
      print(e.toString());
      return [];
    }
  }

  Future<bool> addTeam(String name) async {
    try {
      var url = '${ENDPOINT}/user-add-team';

      var response = await http.post(url,
          headers: header, body: {'user_id': this._id, 'team_name': name});

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

  getUser() async {
    String loginUrl = '${ENDPOINT}/users/login';
    try {
//      var res = await http.post(loginUrl, body: {
//        'email_id': 'developer.gritfusion@gmail.com',
//        'password': '12345'
//      });

      var pref = await SharedPreferences.getInstance();
      this._id = pref.getString('id');
      _tokken = pref.getString('token');
      header = {'x-api-key': 'APIKEY@TEST', 'Auth': _tokken};
    } catch (e) {}

    return _tokken;
  }

  ApiClient() {
    getUser();
  }

  createCustomer(Customer customer) async {
    print(_id);
    print(_tokken);
    var url = '$ENDPOINT/customer_leads/enter-customer-leads-info';

    var response = await http.post(url, body: {
      'user_id': _id,
      ''
          'name': customer.name.toString(),
      'company': customer.company.toString(),
      'email':
          customer.email.toString().replaceAll("[", '').replaceAll(']', ''),
      'event':
          customer.event.toString().replaceAll("[", '').replaceAll(']', ''),
      'address': customer.address.toString(),
      'user_type': 'customer',
      'phone_no':
          customer.phoneNo.toString().replaceAll("[", '').replaceAll(']', '')
    }, headers: {
      'x-api-key': 'APIKEY@TEST',
      'Auth':
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjE1NyIsImVtYWlsX2lkIjoiZGV2ZWxvcGVyLmdyaXRmdXNpb25AZ21haWwuY29tIiwidGltZSI6MTU5ODI1MDM3OX0.Bpo6XsffDelen2d1bU7_jkeQ2yrwClgvbkTLSYRIUBM'
    });

    var data = JsonDecoder().convert(response.body);
    if (data is String) {
      return data;
    }
    if (data['status']) {
      return data;
    }
  }

  moveLeadtoCustomer(Customer customer) async {
    var url = '$ENDPOINT/customer_leads/move-leads-to-customer/${customer.id}';
    var response = await http.put(url, headers: header);

    print('response');
  }

  moveCustomertoLead(Customer customer) async {
    var url = '$ENDPOINT/customer_leads/move-customer-to-leads/${customer.id}';
    var response = await http.put(url, headers: header);

    print('response');
  }

  createLead(Customer customer) async {
    print(_id);
    print(_tokken);
    var url = '$ENDPOINT/customer_leads/enter-customer-leads-info';

    var response = await http.post(url,
        body: {
          'user_id': _id,
          ''
              'name': customer.name.toString(),
          'company': customer.company.toString(),
          'email':
              customer.email.toString().replaceAll("[", '').replaceAll(']', ''),
          'event':
              customer.event.toString().replaceAll("[", '').replaceAll(']', ''),
          'address': customer.address.toString(),
          'user_type': 'leads',
          'phone_no': customer.phoneNo
              .toString()
              .replaceAll("[", '')
              .replaceAll(']', '')
        },
        headers: header);

    var data = JsonDecoder().convert(response.body);
    if (data is String) {
      return data;
    }
    if (data['status']) {
      return data['message'];
    }
  }

  updateCustomerLead(Customer customer) async {
    print(_id);
    print(_tokken);
    var url = '$ENDPOINT/customer_leads/update-customer-lead-details';

    var response = await http.post(url,
        body: {
          'id': customer.id,
          'name': customer.name.toString(),
          'company': customer.company.toString(),
          'email':
              customer.email.toString().replaceAll("[", '').replaceAll(']', ''),
          'event':
              customer.event.toString().replaceAll("[", '').replaceAll(']', ''),
          'address': customer.address.toString(),
          'user_type': customer.userType,
          'phone_no': customer.phoneNo
              .toString()
              .replaceAll("[", '')
              .replaceAll(']', '')
        },
        headers: header);

    var data = JsonDecoder().convert(response.body);
    print(response.body);
    if (data is String) {
      return data;
    }
    if (data['status']) {
      return data['message'];
    }
  }

  Future<BusinessDetails> updateBusinessLogo(PickedFile logo) async {
    var url = '$ENDPOINT//Business_Details/updateBusinessLogo/${this._id}';

    FormData formData = new FormData.fromMap({
      "bussiness_logo": await MultipartFile.fromFile(logo.path,
          filename: logo.path.split("/").last)
    });

    try {
      var res = await Dio().post(url, data: formData);

      print(res);

      var data = JsonDecoder().convert(res.data.toString());

      if (data['status'])
        return BusinessDetails.fromJson(data['update_business_details']);
      else
        return null;
    } catch (e) {
      return null;
    }

    //
    // var request = http.MultipartRequest('POST', Uri.parse(url));
    // request.files.add(
    //     http.MultipartFile(
    //         'bussiness_logo',
    //         logo.readAsBytes().asStream(),
    //         logo.lengthSync(),
    //         filename: logo.path
    //     )
    // );
    // var response = await request.send();
    //
    // print(response.statusCode);
  }

  addUsertoTeam(Team team, SubUser subUser) async {
    var url = '$ENDPOINT/user-add-team-members';
    var response = await http.post(url, headers: header, body: {
      'team_id[0]': team.id,
      'sub_user_id[0]': subUser.id,
      'name[0]': subUser.username[0],
      'email[0]': subUser.emailId[0],
      'team_name[0]': team.name,
      'role[0]': subUser.role,
      'password[0]': subUser.password ?? subUser.plainPassword,
    });

    var data = JsonDecoder().convert(response.body);

    print(data.toString());
  }

  CreateSubUser(name, mobile, pass, email, createdby, role) async {
    var data;
    try {
      var url = '$ENDPOINT/User_registration/insertUser';
      var response = await http.post(url, body: {
        'email_id': email,
        'phone_no': mobile,
        'password': pass,
        'username': name,
        'created_by': this._id,
        'user_type': 'Subuser',
        'role': role,
      });
      data = JsonDecoder().convert(response.body);
      if (!(data is String)) {
        if (data['status']) {
          return data['message'];
        }
      } else {
        return data;
      }
    } catch (e) {
      return e.toString();
    }
  }

  getSubuserData(String id) async {
    var pref = await SharedPreferences.getInstance();
    print(_tokken);
    print(id);
    print('called');
    var url = '$ENDPOINT/admin/User_registration/get-user/$id';
    var apikey = 'APIKEY@TEST';
    var response = await http.get(url, headers: header);

    print(response.body);
    return UserData.fromJson(
        Map.castFrom(JsonDecoder().convert(response.body)));
  }

  addLabel(Customer customer, AddedLabel label) async {
    var url = "$ENDPOINT/customer_leads/leads-customer-add-labels";
    var body = {
      "cus_lead_id[0]": customer.id,
      "userId[0]": _id,
      'label_id[0]': label.id,
      'label_name[0]': label.labelName,
      'color[0]': label.color,
    };
    var response = await http.post(url, headers: header, body: body);

    print(response.body);
  }

  getLabelList() async {
    var url = '$ENDPOINT/Labels/getlabel/${this._id}';
    var apikey = 'APIKEY@TEST';
    var response = await http.get(url, headers: header);

    var data = JsonDecoder().convert(response.body);

    print("labels");
    print(response.body);
    var temp = List<AddedLabel>();
    if (data['status']) {
      var list = data['label_list'];
      for (var l in list) {
        temp.add(AddedLabel.fromJson(l));
      }
    }
    print(temp.length);
    return temp;
  }

  insertLabel(AddedLabel label) async {
    print(_id);
    print(_tokken);
    var url = '$ENDPOINT/Labels/insertLabel/${this._id}';
    var apikey = 'APIKEY@TEST';
    var response = await http.post(url, headers: header, body: {
      'label_name': label.labelName,
      'color': label.color,
    });

    var data = JsonDecoder().convert(response.body);
    print(data.toString());
    if (data['status']) {}
  }

  deleteLabel(AddedLabel l) async {
    print(_id);
    print(_tokken);
    var url = '$ENDPOINT/Labels/deletLabels';

    var apikey = 'APIKEY@TEST';
    var response = await http.post(url, headers: {
      "x-api-key": apikey,
      'Auth': this._tokken
    }, body: {
      'id': l.id,
    });
    var data = JsonDecoder().convert(response.body);
    print(data.toString());
    if (data['status']) {}
  }

  Future<CustomerLabelModel> getLabelCustomers(String labelId) async {
    CustomerLabelModel model;

    var url = "$ENDPOINT/get-total-Labels-customer/get-label/$_id/$labelId";

    var response = await http.get(url);
    print(_id);
    print(labelId);
    print("label");

    var data = JsonDecoder().convert(response.body);

    if (data['status']) {
      model = CustomerLabelModel.fromJson(data);
      return model;
    } else {
      return null;
    }
  }

  Future<List<Document>> getDocumentList() async {
    var url = '$ENDPOINT/get-user-uploaded-documents';
    var res = await http.post(url, body: {"user_id": _id});
    var data = JsonDecoder().convert(res.body);

    List<Document> list = [];

    if (data['status']) {
      list = List.castFrom(List.generate(data["member_details"].length,
          (index) => Document.fromJson(data["member_details"][index])));

      return list;
    } else {
      return list;
    }
  }

  addDocument(Document document, PlatformFile file) async {
    print({
      "user_id": _id,
      "document_name[0]": document.documentName,
      "document_file[0]": await MultipartFile.fromFile(file.path,
          filename: file.path.split("/").last)
    }.toString());

    var url = '$ENDPOINT/upload-documents';
    FormData formData = new FormData.fromMap({
      "user_id": _id,
      "document_name[0]": document.documentName,
      "document_file[0]": await MultipartFile.fromFile(file.path,
          filename: file.path.split("/").last)
    });

    var res = await Dio().post(url, data: formData);

    print(res.toString());
  }

  deleteCustomerLead(Customer customer) async {
    print(_id);
    print(_tokken);
    var url = '$ENDPOINT/customer_leads/delete-customer-leads-list';

    var apikey = 'APIKEY@TEST';
    var response = await http.post(url, headers: {
      "x-api-key": apikey,
      'Auth': this._tokken
    }, body: {
      'id': customer.id,
    });
    var data = JsonDecoder().convert(response.body);
    print(data.toString());
    if (data['status']) {}
  }

  addPriceProposal(PriceProposal priceProposal, File image) async {
    print(_id);
    print(_tokken);
    print({
      'cust_lead_id': priceProposal.custLeadId,
      'cust_lead_name': priceProposal.custLeadName,
      'description': priceProposal.description,
      'quantity': priceProposal.quantity,
      'amount': priceProposal.amount,
      'user_id': _id,
    }.toString());
    var url = '$ENDPOINT/customer_leads/add-price-proposal';
    var res = await http.post(url, body: {
      'cust_lead_id': priceProposal.custLeadId,
      'cust_lead_name': priceProposal.custLeadName,
      'description': priceProposal.description,
      'quantity': priceProposal.quantity,
      'amount': priceProposal.amount,
      'user_id': _id,
    });

    print(res.toString());
  }

  Future<List<PriceProposal>> getPriceProposal() async {
    var url = "$ENDPOINT/customer_leads/get-price-proposal";

    var response = await http.post(url, body: {"user_id": _id});

    var data = JsonDecoder().convert(response.body);
    List<PriceProposal> list = new List();

    if (data['status']) {
      print("done");
      list = List.castFrom(List.generate(data['details'].length,
          (index) => PriceProposal.fromJson(data['details'][index])));

      return list;
    } else {
      return list;
    }
  }

  Future<dynamic> SignUp(name, mobile, pass, email) async {
    var data;
    try {
      var url = '${ENDPOINT}/User_registration/insertUser';
      var response = await http.post(url, body: {
        'email_id': email,
        'phone_no': mobile,
        'password': pass,
        'username': name,
        'created_by': '',
        'user_type': 'Admin',
        'role': '',
      });
      data = JsonDecoder().convert(response.body);

      if (data['status']) {
        return data;
      } else {
        return 'An Error occured';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<Notes>> getNotes(String cus_lead_id) async {
    var url = '$ENDPOINT/customer_leads/get-cutomer-leads-notes-list';
    var pref = await SharedPreferences.getInstance();
    this._id = pref.getString('id');
    this._tokken = pref.getString('token');
    print(_tokken);
    ;
    var apikey = 'APIKEY@TEST';
    var response = await http.post(url,
        body: {'cust_lead_id': cus_lead_id},
        headers: {"x-api-key": apikey, 'Auth': this._tokken});
    var data = JsonDecoder().convert(response.body);

    List<Notes> notes = [];
    try {
      if (data['status'])
        notes = List.castFrom(List.generate(data['notes_list'].length,
            (index) => Notes.fromJson(data['notes_list'][index])));
    } catch (e) {
      print(data);
    }

    return notes;
  }
}
