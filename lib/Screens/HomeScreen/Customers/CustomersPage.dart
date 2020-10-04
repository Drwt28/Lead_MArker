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
import 'package:flutter_olx/CustomWidgets/Button.dart';
import 'package:flutter_olx/CustomWidgets/Label.dart';
import 'package:flutter_olx/CustomWidgets/style.dart';
import 'package:flutter_olx/Model/Customers.dart';
import 'package:flutter_olx/Model/UserData.dart';
import 'package:flutter_olx/Provider/User.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';
import 'package:flutter_olx/Screens/HomeScreen/Customers/AddCustomerPage.dart';
import 'package:flutter_olx/Screens/ShareLeadCustomer/ShareWithTeam.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

//class CustomersPage extends StatefulWidget {
//  var customerList = List<Customer>();
//  var addedcustomerLabel = [];
//
//
//  CustomersPage(this.customerList, this.addedcustomerLabel);
//
//  @override
//  customerListPageState createState() => customerListPageState();
//}

//class customerListPageState extends State<CustomersPage> {
//
//
//  var customerList = List<Customer>();
//  var addedcustomerLabel = [];
//  var expanded = [false, false];
//
//
//  @override
//  void initState() {
//    super.initState();
//    getData();
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    customerList = widget.customerList;
//    addedcustomerLabel = widget.addedcustomerLabel;
//
//    if(expanded.length==0)
//      expanded = List.generate(widget.customerList.length + 1, (index) => false);
//    return SafeArea(
//      child: Scaffold(
//        body: (customerList.length > 0) ? ListView(
//          children: List.generate(
//              customerList.length,
//                  (index) =>
//                  buildSingleTile(context,customerList[index].expanded,
//                      customer: customerList[index],
//                      isCustomer: true,
//                      lead: customerList[index],
//                      labels: widget.addedcustomerLabel.where((element) => element.cusLeadId==widget.customerList[index].id).toList()??[],
//                      expPressed: () {
//                        widget.customerList[index].expanded = !widget.customerList[index].expanded;
//
//                        setState(() {});
//                      },
//                      deletePressed: () async {
//                        var status = await deleteCustomer(customerList[index]);
//                        setState(() {
//
//                        });
//                        print(status);
//                      })),
//        )
//            : Center(child: CircularProgressIndicator(),),
//        floatingActionButton: FloatingActionButton(
//          heroTag: 'jkh',
//          backgroundColor: red,
//          child: Icon(Icons.add),
//          onPressed: () async{
////               getdata();
//           final dec  = await  Navigator.push(context,
//                MaterialPageRoute(builder: (context) => AddCustomerPage()));
//                getData();
//                setState(() {
//
//                });
//          },
//        ),
//      ),
//    );
//  }
//
//  String _id,_tokken;
//getData() async {
//    var pref = await SharedPreferences.getInstance();
//    this._id = pref.getString('id');
//    this._tokken = pref.getString('token');
//    try {
//      var url =
//          'http://radient.appnitro.co/api/Customer/getCustomerList/${this._id}';
//      var apikey = 'APIKEY@TEST';
//      var response = await http
//          .get(url, headers: {"x-api-key": apikey, 'Auth': this._tokken});
//      var data = JsonDecoder().convert(response.body);
//      var customers = data['customer_list'];
//      var temp = List<Customer>();
//      for (var customer in customers) {
//        temp.add(Customer.fromJson(customer));
//      }
//
//      customerList = temp;
//      expanded = List.generate(customerList.length + 1, (index) => false);
//      setState(() {});
//    } catch (e)
//    {
//      print(e.toString());
//    }
//
//
//    print('called');
//
//  }
//  Future<List<Customer>> deleteCustomer(Customer customer) async {
//    var url = 'http://radient.appnitro.co/api/Customer/deleteCustomer';
//    try {
//      var apikey = 'APIKEY@TEST';
//      var response = await http.post(url, headers: {
//        "x-api-key": apikey,
//        'Auth': this._tokken
//      }, body: {
//        'customer_id': customer.id,
//      });
//      var data = JsonDecoder().convert(response.body);
//      print(customer.id);
//      if (data['status']) {
//        customerList.remove(customer);
//      } else {
//
//
//      }
//    } catch (e) {
//      return customerList;
//    }
//  }
//
//}

class CustomersPage extends StatefulWidget {
  User user;
  List<Customer> customers;
  List<AddedLabel> labelList;

  CustomersPage({this.customers, this.labelList});

  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    leadList = [];
    getdata();
  }
  String _id, _tokken;
  var expanded = [false];

  var customers = [];

  Future<List<Customer>> getdata() async {
    {

      Provider.of<UserDataProvider>(context, listen: false)
          .getUserData();
    }
  }


  var leadList;

  ApiClient apiClient = ApiClient();
  PersistentBottomSheetController controller;

  buildAddLabelDialog(Customer customer) {
    showDialog(
        context: context,
        child: StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(
              "Add Label to ${customer.name}",
              style:
              Theme.of(context).textTheme.headline6,
            ),
            actions: [
              FlatButton(
                child: Text('Add Labels'),
                onPressed: () {
                  var list =
                  labels.where((element) => element.isSelected).toList();

                  for(int i = 0 ; i < list.length;i++)
                  {
                    apiClient.addLabel(
                        customer, list[i]);
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
                reverse: true,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: List.generate(
                    labels.length,
                        (index) => CheckboxListTile(
                      onChanged: (val) {
                        setState(() {
                          labels[index].selected = val;
                        });
                      },
                      value: labels[index].isSelected,
                      title: SizedBox(
                          height: 25,
                          child: RadientLabel(
                              labels[index].color, labels[index].labelName)),
                    )),
              ),
            ),
          ),
        ));
  }

  buildOptionDialog(Customer customer) {
    showDialog(
        useRootNavigator: true,
        context: context,
        child: FittedBox(
          child: AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: Column(
              children: [ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>EditCustomerPage(customer)));
                },
              ),
                ListTile(
                  title: Text('Send Email'),
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
  Map<String,List<Notes>> notesMap = Map();

  @override
  Widget build(BuildContext context) {
    notesMap = Provider.of<UserDataProvider>(context).notesMap;
    labels = Provider.of<UserDataProvider>(context).labelList;
    customers = Provider.of<UserDataProvider>(context).userData.customer;
    print(leadList.length);
    if (expanded.length == 0)
      expanded = List.generate(customers.length + 1, (index) => false);
    return Scaffold(
        body: (customers==null)?Center(child: CircularProgressIndicator()):(customers.length > 0)
            ? ListView(scrollDirection: Axis.vertical, children: [
          Text(
            'Long press for more option',
            style: TextStyle(color: Colors.black38),
            textAlign: TextAlign.center,
          ),
          AnimationLimiter(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: customers.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (cxt, index) {
                  List<AddedLabel> labels = widget.labelList
                      .where((element) =>
                  element.cusLeadId == customers[index].id)
                      .toList();
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 575),
                    child: SlideAnimation(
                      verticalOffset: -100,
                      child: FadeInAnimation(
                        child: buildSingleTile(
                            context, customers[index].expanded,
                            labels: labels,
                            note: notesMap[customers[index].id.toString()]??[Notes(note: "No Notes Yet")],
                            onLongPress: () {
                              buildOptionDialog(customers[index]);
                            },
                            customer: customers[index],
                            lead: customers[index],
                            isCustomer: true,
                            expPressed: () {
                              customers[index].expanded =
                              !customers[index].expanded;
                              setState(() {});
                            },
                            deletePressed: () async {
                              Provider.of<UserDataProvider>(context,listen: false).deleteCustomerLead(customers[index]);
                              customers.remove(customers[index]);
                            }),
                      ),
                    ),
                  );
                }),
          )
        ])
            : Center(child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddCustomerPage()));
            },
            child: Text("No Customer Added",style: Theme.of(context).textTheme.headline6,)),),
//              )),

        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          heroTag: 'add lead',
          backgroundColor: red,
          child: Icon(Icons.add),
          onPressed: () async {
//               getdata();
            final dec = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddCustomerPage()));
            print(dec);
            if (dec) {
              getdata();
            }
          },
        ));
  }

  Future<bool> handlePermissions() async {
    var status = await Permission.contacts.request();

    return status.isGranted;
  }

  var _animationListState = GlobalKey<AnimatedListState>();
}



class ImportDeviceContactPage extends StatefulWidget {


  bool isCustomer;


  ImportDeviceContactPage(this.isCustomer);

  @override
  _ImportDeviceContactPageState createState() =>
      _ImportDeviceContactPageState();
}

class _ImportDeviceContactPageState extends State<ImportDeviceContactPage>
    with AutomaticKeepAliveClientMixin {
  List<bool> isSelected;
  List<Contact> selectedContacts = List();
  List<Contact> contactList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContacts();
  }

  var loading = false;
  ApiClient apiClient = ApiClient();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Select Contacts'),

          actions: [
            (selectedContacts!=null)?IconButton(
              onPressed: (){
                showDialog(context: context,child: AlertDialog(

                  title: Text("Are you sure to Import"),
                  actions: [

                    FlatButton(onPressed: ()async{
                      Navigator.pop(context);
                      setState(() {
                        loading = true;
                      });
                      for(var con in selectedContacts)
                      {

                        List phones = [];

                        for(var it in con.phones)
                          {
                            phones.add(it.value);
                          }
                        Customer cust = Customer(company: con.company??'',
                          email: con.emails.toList()??'',
                          address: con.postalAddresses.toList().toString()??'',
                          name: con.displayName.toString()??'',
                          phoneNo: phones,

                        );


                        if(widget.isCustomer)
                        await   apiClient.createCustomer(cust);
                        else
                          await apiClient.createLead(cust);
                      }

                      setState(() {
                        loading=false;
                      });
                      await Provider.of<UserDataProvider>(context,listen: false).getUserData();

                      showDialog(context: context,child: AlertDialog(
                        title: Text("Imported Successfully"),
                        actions: [
                          FlatButton(
                            child: Text("ok"),
                            onPressed: (){
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },)
                        ],
                      ));
                    }, child: Text("import")),
                    FlatButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: Text("cancel")),
                  ],
                ));
              },
              icon: Icon(Icons.check_circle,color: Colors.white,),

            ):SizedBox()
          ],
        ),
        body: !(contactList == null||loading)
            ? ListView.builder(
            itemCount: contactList.length ?? 0,
            itemBuilder: (context, index) =>
            (contactList[index].displayName == null)
                ? SizedBox()
                : ListTile(
              trailing: isSelected[index]
                  ? Icon(
                Icons.check_circle,
                color: Colors.green,
              )
                  : SizedBox(),
              title: Text(contactList[index].displayName ?? ''),
              onTap: () {
                isSelected[index] = !isSelected[index];
                if (isSelected[index]) {
                  selectedContacts.add(contactList[index]);
                } else {
                  selectedContacts.remove(contactList[index]);
                }
                setState(() {});
              },
            ))
            : Center(
          child: CircularProgressIndicator(),
        ));
  }

  Future<Iterable<Contact>> getContacts() async {
    print('called');
    Iterable<Contact> contacts = await ContactsService.getContacts();
    print(contacts.toString());
    contactList = contacts.toList();
    isSelected = List.generate(contacts.toList().length, (index) => false);

    setState(() {});
  }

  @override

  bool get wantKeepAlive => true;
}
