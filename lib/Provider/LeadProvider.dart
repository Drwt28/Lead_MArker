import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_olx/Model/Lead.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LeadProvider with ChangeNotifier{
  List<Lead> _leads;
  String _id;
  String _tokken;


  getLeadList() async {
    try {
      var pref = await SharedPreferences.getInstance();
      this._id = pref.getString('id');
      this._tokken = pref.getString('token');
      print(_tokken);
      var url = 'http://flutter_olx.appnitro.co/api/Leads/getLeadsList/${this._id}';
      var apikey = 'APIKEY@TEST';
      var response = await http
          .get(url, headers: {"x-api-key": apikey, 'Auth': this._tokken});
      var data = JsonDecoder().convert(response.body);
      print(data);
      var leads = data['lead_list'];
      var temp_list = List();
      for (var lead in leads) {
        var temp = Lead.fromJson(lead);
//        temp.labels = await getleadLabel(temp.id);
//        print(temp.labels.toString());
        temp_list.add(temp);
      }
      _leads = temp_list;
      notifyListeners();

    } catch (e) {

    }


  }

  List<Lead> get leads => _leads;

}