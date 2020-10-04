import 'dart:convert';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_olx/CustomWidgets/CustomerLeadModel.dart';
import 'package:flutter_olx/Model/Notes.dart';
import 'package:flutter_olx/Screens/HomeScreen/Lead/EditCustomerPage.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_olx/Api/ApiClient.dart';

import 'package:flutter_olx/CustomWidgets/Label.dart';
import 'package:flutter_olx/CustomWidgets/style.dart';
import 'package:flutter_olx/Model/Label.dart';
import 'package:flutter_olx/Model/Lead.dart';
import 'package:flutter_olx/Model/UserData.dart';
import 'package:flutter_olx/Provider/LeadProvider.dart';
import 'package:flutter_olx/Provider/User.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';
import 'package:flutter_olx/Screens/HomeScreen/Lead/AddLeadPage.dart';
import 'package:flutter_olx/Screens/ShareLeadCustomer/ShareWithTeam.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class LeadPage extends StatefulWidget {
  User user;
  List<Customer> leads;
  List<AddedLabel> labelList;

  LeadPage({this.leads, this.labelList});

  @override
  _LeadPageState createState() => _LeadPageState();
}

class _LeadPageState extends State<LeadPage> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    leadList = [];
    getdata();

    animationController =
        AnimationController(duration: Duration(milliseconds: 1200), vsync: this)
          ..addListener(() {
            setState(() {});
          });



    animation = Tween<double>(begin: -500, end: 0.0).
    animate(
        CurvedAnimation(curve: Curves.bounceOut, parent: animationController));

    animationController.forward();
  }

  String _id, _tokken;
  var expanded = [false];

  Future<List<Lead>> getdata() async {
    {
      Provider.of<UserDataProvider>(context, listen: false).getUserData();
    }
  }

  Future<bool> deleteLead(Lead lead) async {
    try {
      leadList.remove(lead);
      var url = 'http://radient.appnitro.co/api/leads/delete-leads-details';
      var apikey = 'APIKEY@TEST';
      var response = await http.post(url, headers: {
        "x-api-key": apikey,
        'Auth': this._tokken
      }, body: {
        'leads_id': lead.id,
      });

      var data = JsonDecoder().convert(response.body);
      if (data['status']) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  var leadList;

  ApiClient apiClient = ApiClient();
  PersistentBottomSheetController controller;

  buildAddLabelDialog(Customer customer) {
    var addedLabels = widget.labelList
        .where((element) => element.cusLeadId == customer.id)
        .toSet();

    var allLabels = labels.toSet();

    var unAddedLabels = labels.toSet().difference(addedLabels).toList();

    showDialog(
        context: context,
        child: StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(
              "Add Label to ${customer.name}",
              style: Theme.of(context).textTheme.headline6,
            ),
            actions: [
              FlatButton(
                child: Text('Add Labels'),
                onPressed: () async {
                  var list = unAddedLabels
                      .where((element) => element.isSelected)
                      .toList();

                  for (int i = 0; i < list.length; i++) {
                    await apiClient.addLabel(customer, list[i]);
                  }

                  Provider.of<UserDataProvider>(context, listen: false)
                      .getUserData();
                  Navigator.pop(context);
                },
              ),
            ],
            content: Container(
              height: 200,
              width: 250,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: List.generate(
                    unAddedLabels.length,
                    (index) => CheckboxListTile(
                          onChanged: (val) {
                            setState(() {
                              unAddedLabels[index].selected = val;
                            });
                          },
                          value: unAddedLabels[index].isSelected,
                          title: SizedBox(
                              height: 25,
                              child: RadientLabel(unAddedLabels[index].color,
                                  unAddedLabels[index].labelName)),
                        )),
              ),
            ),
          ),
        ));
  }

  buildOptionDialog(Customer customer) {
    // var permission = Provider.of<UserDataProvider>(context).userPermission;
    showDialog(
        useRootNavigator: true,
        context: context,
        child: FittedBox(
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit'),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditCustomerPage(customer)));
                  },
                ),
                ListTile(
                  title: Text('Send Message'),
                  onTap: () {
                    try {
                      launch("sms: +91 ${customer.phoneNo[0]}");
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
                ListTile(
                  title: Text('Edit Labels'),
                  onTap: () {
                    Navigator.pop(context);
                    buildAddLabelDialog(customer);
                  },
                ),
                ListTile(
                  title: Text('Move to Customer List'),
                  onTap: () async {
                    Navigator.pop(context);
                    await apiClient.moveLeadtoCustomer(customer);
                    Provider.of<UserDataProvider>(context, listen: false)
                        .getUserData();
                  },
                ),
                ListTile(
                  title: Text('Share With Team'),
                  onTap: () async {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShareWithTeam(customer)));
                  },
                ),
              ],
            ),
          ),
        ));
  }

  var labels = [];
  Map<String, List<Notes>> notesMap = Map();

  @override
  Widget build(BuildContext context) {
    notesMap = Provider.of<UserDataProvider>(context).notesMap;
    labels = Provider.of<UserDataProvider>(context).labelList;
    leadList = Provider.of<UserDataProvider>(context).userData.leads;
    print(leadList.length);

    return Scaffold(
        body: (widget.leads == null)
            ? Center(child: CircularProgressIndicator())
            : (widget.leads.length > 0)
                ? ListView(scrollDirection: Axis.vertical, children: [
                    Text(
                      'Long press for more option',
                      style: TextStyle(color: Colors.black38),
                      textAlign: TextAlign.center,
                    ),
                    AnimationLimiter(
                      child: ListView.builder(
                          reverse: true,
                          scrollDirection: Axis.vertical,
                          itemCount: widget.leads.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (cxt, index) {
                            List<AddedLabel> labels = widget.labelList
                                .where((element) =>
                                    element.cusLeadId == widget.leads[index].id)
                                .toList();

                            return AnimationConfiguration.staggeredList(

                              position: index,
                              duration: const Duration(milliseconds: 475),
                              child: SlideAnimation(
                                horizontalOffset: 100.0,
                                child: FadeInAnimation(
                                  child: buildSingleTile(
                                      context, widget.leads[index].expanded,
                                      labels: labels,
                                      note: notesMap[leadList[index].id.toString()] ??
                                          [Notes(note: "No Notes Yet")],
                                      onLongPress: () {
                                        buildOptionDialog(widget.leads[index]);
                                      },
                                      customer: widget.leads[index],
                                      lead: widget.leads[index],
                                      isCustomer: false,
                                      expPressed: () {
                                        widget.leads[index].expanded =
                                            !widget.leads[index].expanded;
                                        setState(() {});
                                      },
                                      deletePressed: () async {
                                        Provider.of<UserDataProvider>(context,
                                                listen: false)
                                            .deleteCustomerLead(widget.leads[index]);
                                        widget.leads.remove(widget.leads[index]);
                                      }),
                                ),
                              ),
                            );
                          }),
                    )
                  ])
                : Center(
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddLeadPage()));
                        },
                        child: Text(
                          "No Leads Added",
                          style: Theme.of(context).textTheme.headline6,
                        )),
                  ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          heroTag: 'add 121',
          backgroundColor: red,
          child: Icon(Icons.add),
          onPressed: () async {
//               getdata();
            final dec = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddLeadPage()));
            print(dec);
            if (dec) {
              getdata();
            }
          },
        ));
  }

  lockTile(String title) {
    return ListTile(
      title: Text(title),
      trailing: Icon(
        Icons.lock,
        color: Colors.red,
      ),
    );
  }

  Future<bool> handlePermissions() async {
    var status = await Permission.contacts.request();

    return status.isGranted;
  }

  var _animationListState = GlobalKey<AnimatedListState>();
}
