import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_olx/Api/ApiClient.dart';
import 'package:flutter_olx/Model/BusinessDetails.dart';
import 'package:flutter_olx/Model/Document.dart';
import 'package:flutter_olx/Model/Notes.dart';
import 'package:flutter_olx/Model/PriceProposal.dart';
import 'package:flutter_olx/Model/RecievedList.dart';
import 'package:flutter_olx/Model/Team.dart';
import 'package:flutter_olx/Model/TeamMember.dart';
import 'package:flutter_olx/Model/UserData.dart';
import 'package:flutter_olx/Model/UserPermission.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserDataProvider extends ChangeNotifier{

  UserPermission userPermission = UserPermission("Admin");



List labelList = [];
List totalCustomers = [];
List teams = [];

List<PriceProposal> priceProposalList ;

Map<String,List<Notes>> notesMap = new Map();
List<ApprovedList> receivedCusLeadList=[];
List<ApprovedList> sentCustLeadList=[];

BusinessDetails businessDetails=BusinessDetails('','','','','','','');

addPriceProposal(PriceProposal priceProposal,image)
async {
  await apiClient.addPriceProposal(priceProposal, image);
  getPriceProposal();
}

getPriceProposal()async{

priceProposalList =   await apiClient.getPriceProposal();
notifyListeners();

}

addNote(Notes n,id)
{
  notesMap[id].add(n);
  notifyListeners();
}

getRecievedLeadCusList()async{
  receivedCusLeadList = List.castFrom(await apiClient.getRecievedList());
  notifyListeners();
}
getSentCusLead()async{
  sentCustLeadList= await apiClient.getSentList();
  notifyListeners();
}

approveLeadCust(String id)async{
  await apiClient.approveLeadCust(id);
 getRecievedLeadCusList();
 notifyListeners();
 getUserData();

}

updateBusinessDetails(BusinessDetails businessDetails)
{
  this.businessDetails = businessDetails;
  apiClient.setbusinessDetails(businessDetails);
  notifyListeners();
}
getBusinessDetails()async{
 businessDetails = (await  apiClient.getBusinessDetails())??BusinessDetails('','','','','','','');
 notifyListeners();
}

shareWithTeam(TeamMember teamMember,Customer customer)
async{
  await apiClient.shareWithTeam(teamMember, customer);

}

deleteCustomerLead(Customer customer)
async{
 await  apiClient.deleteCustomerLead(customer);
 getUserData();
}

Future<List<Team>>getTeamList()async{
  teams = await apiClient.getTeamList();
  notifyListeners();
}

Future<List<TeamMember>> getTeamMembers(int index)
async{
  List<TeamMember> members = [];
 if(teams.length>0)
   {
    members = await apiClient.getTeamMembersList(teams[index].id);
    teams[index].members = members;
    notifyListeners();
    return members;
   }
 else{
   return [];

 }
}

getLabelList()async{

 labelList = await apiClient.getLabelList();
 getTeamList();
 notifyListeners();
}

  ApiClient apiClient =ApiClient();
  UserDataProvider(){
    getUserData();
    getBusinessDetails();
    getPermissions();

  }

  deleteTeam(int index){
    apiClient.deleteTeam(teams[index].id);
    teams.removeAt(index);
    notifyListeners();

  }

getUserData() async {
  var pref = await SharedPreferences.getInstance();
  String _id = pref.getString('id');

  getBusinessDetails();
userData = await apiClient.getSubuserData(_id);


totalCustomers = List.from(userData.customer);
  getLabelList();
  notifyListeners();
  totalCustomers.addAll(userData.leads);
  for(var c in  totalCustomers)
  {
    notesMap[c.id]  = await apiClient.getNotes(c.id);
  }
  notifyListeners();
}


  UserData userData = UserData(customer: [],customerAddedLabels: [],leads: [],leadsAddedLabel: [],message: '',subUsers: [],userList: []);

   LogOut() async{
     var pref = await SharedPreferences.getInstance();
     pref.clear();

   }


   updateBusinessLogo(PickedFile file)
  async {
     var data = await apiClient.updateBusinessLogo(file);
     if(data!=null)
       businessDetails = data;

     getBusinessDetails();
     notifyListeners();
   }
   getPermissions() async{
     var pref = await SharedPreferences.getInstance();
     userPermission = UserPermission(pref.getString("role"));
     notifyListeners();
   }

   List<Document> documents;
   getDocuments()async {
     documents =await  apiClient.getDocumentList();
     notifyListeners();
   }

}