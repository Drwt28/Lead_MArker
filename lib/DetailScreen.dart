import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_olx/Api/ApiClient.dart';
import 'package:flutter_olx/CustomWidgets/Utils.dart';
import 'package:flutter_olx/Screens/Document/DocumentListPage.dart';
import 'package:flutter_olx/Screens/HomeScreen/Task/AddTaskPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_olx/AddNotesPage.dart';
import 'package:flutter_olx/CustomWidgets/Button.dart';
import 'package:flutter_olx/CustomWidgets/Label.dart';
import 'package:flutter_olx/CustomWidgets/style.dart';
import 'package:flutter_olx/Model/Notes.dart';
import 'package:flutter_olx/Provider/User.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'Model/UserData.dart';
import 'Screens/PriceProposal/PriceProposalList.dart';

class detailScreen extends StatefulWidget {
  List labels = [];
  Customer lead;
  Customer customer;
  bool isCustomer;

  detailScreen({this.lead, this.customer, this.isCustomer, this.labels});

  @override
  _detailScreenState createState() => _detailScreenState();
}

class _detailScreenState extends State<detailScreen> {
  var deleteCustomerNotesUrl =
      "http://radient.appnitro.co/api/customer_notes/delete-notes";
  var deleteLeadNotesUrl =
      "http://radient.appnitro.co/api/leads_notes/delete-notes";
  var getLeadNotesUrl = "http://radient.appnitro.co/api/leads_notes/get-notes/";
  var getCustomerNotesUrl =
      "http://radient.appnitro.co/api/customer_notes/get-notes/";

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  Task task;

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    List tasks = Provider.of<UserDataProvider>(context).userData.userTasks;
    List customers = Provider.of<UserDataProvider>(context).totalCustomers;

//      task = tasks.firstWhere((element) => element.cust_lead_id==widget.customer.id);
    return Scaffold(
      key: scaffoldKey,
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverAppBar(
            stretch: true,
            expandedHeight: MediaQuery.of(context).size.height * .3,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              centerTitle: true,
              background: Container(
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.customer.name,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: Colors.white),
                          ),
                          Text(
                            widget.isCustomer
                                ? widget.customer.phoneNo
                                        .toString()
                                        .replaceFirst("[", "")
                                        .replaceFirst("]", "") ??
                                    widget.customer.name
                                : widget.lead.phoneNo
                                        .toString()
                                        .replaceAll("[", "")
                                        .replaceAll("]", "") ??
                                    widget.lead.phoneNo
                                        .toString()
                                        .replaceAll("[", "")
                                        .replaceAll("]", ""),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildSingleRoundButton(Icons.call, () {
                            // Lead l;
                            try {
                              launch("tel: ${widget.lead.phoneNo[0]}");
                            } catch (e) {
                              print(e);
                            }
                          }),
                          buildSingleRoundButton(Icons.chat, () {
                            try {
                              launch("sms:${widget.lead.phoneNo[0]}");
                            } catch (e) {
                              print(e);
                            }
                          }),
                          buildSingleRoundButton(Icons.mail, () {
                            try {
                              launch("mailto:${widget.lead.email[0]}");
                            } catch (e) {
                              print(e);
                            }
                          }),
                          buildSingleRoundButton(Icons.location_on, () {
                            try {
                              launch(
                                  'https://www.google.com/maps/search/?api=1&query=${widget.lead.address}');
                            } catch (e) {
                              print(e);
                            }
                          }),
                          buildSingleRoundButton(FontAwesomeIcons.whatsapp, () {
                            try {
                              launch(
                                  'https://api.whatsapp.com/send?phone="+number91${widget.lead.phoneNo[0]}');
                            } catch (e) {
                              print(e);
                            }
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              buildSingleButton(Icons.share, () {
                final RenderBox box = context.findRenderObject();
                Share.share(
                    "Sharing the details of my customer\n Name :${widget.customer.name}\n${widget.customer.company}\n${widget.customer.phoneNo.toString()}\n${widget.customer.email.toString()}\n",
                    subject: 'Sharing my customers',
                    sharePositionOrigin:
                        box.localToGlobal(Offset.zero) & box.size);
              }),
              SizedBox(
                width: 20,
              )
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              buildSingleRowTile(Colors.blue, () {
                buildAddLabelDialog(widget.customer);
              },
                  'images/Icons/labels.png',
                  SizedBox(
                    height: 23,
                    child: ListView(
                      children: List.generate(
                          widget.labels.length,
                          (index) => RadientLabel(widget.labels[index].color,
                              widget.labels[index].labelName)),
                      scrollDirection: Axis.horizontal,
                    ),
                  )),
              buildSingleRowTile(red, () {
                int index = customers.indexOf(widget.customer);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddTaskPage(
                              selected: index,
                            )));
              },
                  'images/Icons/task.png',
                  task == null
                      ? Text(
                          'Add Follow up task',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: Colors.black),
                        )
                      : SizedBox(
                          height: 50,
                          child: ListTile(
                            title: Text("Added on  ${task.remainderDate}"),
                            subtitle: Text(
                              task.description,
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        )),
              buildSingleRowTile(Colors.yellow, () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => AddNotesPage(
                              id: widget.isCustomer
                                  ? widget.customer.id
                                  : widget.lead.id,
                              isCustomer: widget.isCustomer,
                            )));
              },
                  'images/Icons/notes.png',
                  Text('Add Notes',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.black))) ,

              buildSingleRowTile(Colors.green, () {
                Navigator.push(context, MaterialPageRoute
                  (
                    builder: (context)=>DocumentListPage()
                ));
              },
                  'images/Icons/invoice.png',
                  Text('Share Documents',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.black))) ,

              buildSingleRowTile(red, () {
                Navigator.push(context, MaterialPageRoute
                  (
                    builder: (context)=>PriceProposalList()
                ));
              },
                  'images/Icons/invoice.png',
                  Text('Price Proposals',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.black))),

              notes.length > 0
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                      child: Text(
                        'Last Added Notes',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Colors.black),
                      ))
                  : SizedBox(),
              ListView.builder(
                itemBuilder: (context, index) => Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(notes[index].note),
                    subtitle: Text(notes[index].date.toString()),
                  ),
                ),
                itemCount: notes.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              )
            ]),
          )
        ],
      ),
    );
  }

  buildSingleButton(icon, onpressed) {
    return IconButton(
      onPressed: onpressed,
      icon: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  buildSingleRowTile(color, onpresseed, image, widget) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        child: ListTile(
          onTap: onpresseed,
          leading: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Image.asset(
                image,
                height: 30,
                width: 30,
                color: Colors.white,
              )),
          title: widget,
        ),
      ),
    );
  }

  buildSingleRoundButton(icon, onpressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FloatingActionButton(
        mini: true,
        elevation: 0,
        heroTag: icon.toString(),
        onPressed: onpressed,
        backgroundColor: Colors.white,
        child: Icon(
          icon,
          color: Colors.red,
        ),
      ),
    );
  }

  PersistentBottomSheetController controller;
  var selcted = List<bool>();

  addLabelDialog(lead, User user) async {
    var labels = await user.getLabelList();
    selcted = List.generate(labels.length, (index) => false);

    controller =
        scaffoldKey.currentState.showBottomSheet((context) => AlertDialog(
              elevation: 0,
              title: Text('Choose label'),
              content: Container(
                child: Column(
                  children: List.generate(
                      labels.length,
                      (index) => CheckboxListTile(
                            onChanged: (val) {
                              controller.setState(() {
                                selcted[index] = val;
                              });
                            },
                            value: selcted[index],
                            title: RadientLabel(
                                Color(int.parse(labels[index].color)),
                                labels[index].text),
                          )),
                ),
              ),
              actions: [
                RadientFlatButton('No', Colors.black, () {
                  Navigator.pop(context);
                }),
                RadientGradientButton(context, 34.0, 70.0, () async {
                  controller.setState(() {});
                }, 'Yes')
              ],
            ));
    //   showDialog(context: context,child:  );
  }

  List<Notes> notes = [];
  String _id, _tokken;

  getNotes() async {
    var url =
        'http://radient.appnitro.co/api/customer_leads/get-cutomer-leads-notes-list';
    var pref = await SharedPreferences.getInstance();
    this._id = pref.getString('id');
    this._tokken = pref.getString('token');
    print(_tokken);
    ;
    var apikey = 'APIKEY@TEST';
    var response = await http.post(url,
        body: {'cust_lead_id': widget.customer.id},
        headers: {"x-api-key": apikey, 'Auth': this._tokken});

    var data = JsonDecoder().convert(response.body);
    print(data);

    notes = List.castFrom(List.generate(data['notes_list'].length,
        (index) => Notes.fromJson(data['notes_list'][index])));
    setState(() {});
  }

  ApiClient apiClient = ApiClient();

  buildAddLabelDialog(Customer customer) {
    var labels =
        Provider.of<UserDataProvider>(context, listen: false).labelList;
    var labelList = widget.isCustomer
        ? Provider.of<UserDataProvider>(context, listen: false)
            .userData
            .customerAddedLabels
        : Provider.of<UserDataProvider>(context, listen: false)
            .userData
            .leadsAddedLabel;
    var addedLabels =
        labelList.where((element) => element.cusLeadId == customer.id).toSet();

    var allLabels = labels.toSet();

    var unAddedLabels = labels.toSet().difference(addedLabels).toList();

    showDialog(
        context: context,
        child: StatefulBuilder(
          builder: (context, setstate) => AlertDialog(
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
                    if(!widget.labels.contains(list[i]))
                      {
                        await apiClient.addLabel(customer, list[i]);
                        widget.labels.add(list[i]);

                      }

                    setState(() {});
                  }
                  Navigator.pop(context);

                  Provider.of<UserDataProvider>(context, listen: false)
                      .getUserData();
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
                            setstate(() {
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
}
