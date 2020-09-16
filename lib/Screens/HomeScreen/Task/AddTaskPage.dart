import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:flutter_olx/Api/ApiClient.dart';
import 'package:flutter_olx/CustomWidgets/Button.dart';
import 'package:flutter_olx/CustomWidgets/TextField.dart';
import 'package:flutter_olx/CustomWidgets/style.dart';
import 'package:flutter_olx/Model/UserData.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';

class AddTaskPage extends StatefulWidget {
  int selected;


  AddTaskPage({this.selected});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

PersistentBottomSheetController _controller;

class _AddTaskPageState extends State<AddTaskPage> {
  List<bool> selected = List.generate(15, (index) => false);
  ApiClient apiClient  = ApiClient();


  @override
  void initState() {
    selectedIndex = widget.selected;
    if(selectedIndex!=-1)
    setState(() {

    });
  }

  Widget buildSelectUserWidget(List customers) {
    List<bool> selected = List.generate(customers.length, (index) => false);

    showDialog(
        context: context,
        child: StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(
              "Choose Customer/Lead",
              style:
              Theme.of(context).textTheme.headline6,
            ),
            actions: [
              FlatButton(
                child: Text('Done'),
                onPressed: () {

                  Navigator.pop(context);
                },
              ),
            ],
            content: Container(
             height: 300,
              width: 250,
              child: ListView.builder(
                shrinkWrap: true,
                itemExtent: 60,
                itemBuilder: (context, index) =>
                    buildSingleSelectTile(customers[index], index, selected,setState),
                itemCount: customers.length,
              ),
            ),
          ),
        ));


  }

  var selectedIndex = -1;



  Widget buildSingleSelectTile(Customer customer, index, selected,setstate) {


    return RadioListTile(
      groupValue: selectedIndex,
      value: index,
      onChanged: (val) {
        setState(() {
          selectedIndex = index;
        });    setstate(() {

        });
      },
      title: Text(customer.name + "\t${customer.company}"),
      subtitle: Text(customer.userType),
    );
  }

  var scaffold = GlobalKey<ScaffoldState>();

  var remDate;
  var note ='';
  var formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    List customers = Provider.of<UserDataProvider>(context).totalCustomers;
    return Scaffold(
      key: scaffold,
      appBar: AppBar(
        title: Text('Add Follow up/Task'),
      ),
      floatingActionButton:
          selectedIndex==-1?SizedBox():RadientGradientButton(context, 40.0, 100.0, () async{
            if(formkey.currentState.validate())
            Navigator.pop(context);
            await  apiClient.addTask(Task(cust_lead_id: customers[selectedIndex].id,remainderDate:remDate,description: note ));
            Provider.of<UserDataProvider>(context,listen: false).getUserData();
            
          }, 'Ok'),
      body: Form(
        key: formkey,
        child: ListView(
          children: [
            buildSingleTile(Icons.notifications_none, 'Set Remainder Date', () async {
              var currentDate = DateTime.now();

             remDate = await  showDatePicker(
               initialDatePickerMode: DatePickerMode.day,
                  context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate:  DateTime(currentDate.year, 12, currentDate.day));
             setState(() {

             });
              // DatePicker.showDatePicker(context,
              //     showTitleActions: true,
              //     minTime: DateTime(
              //         currentDate.year, currentDate.month, currentDate.day),
              //     maxTime: DateTime(currentDate.year, 12, currentDate.day),
              //     onChanged: (date) {
              //   print('change $date');
              // }, onConfirm: (date) {
              //   print('confirm $date');
              //   remDate = date;
              //   setState(() {
              //
              //   });
              // }, currentTime: DateTime.now());
            }, remDate!=null?remDate.toString():'Pick Time and Date'),
            buildDivider(),
            buildSingleTile(Icons.account_circle, 'Select Customer/Lead Optional',
                () {
              buildSelectUserWidget(customers);
            }, selectedIndex!=-1?customers[selectedIndex].name:'select Customer'),
            buildDivider(),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.note_add,
                      color: red,
                      size: 30,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        onChanged: (val){
                          note = val;
                          setState(() {

                          });
                        },
                        validator: (val)=>val.isEmpty?'enter note':null,
                        minLines: 2,
                        maxLines: 20,
                        decoration: InputDecoration(
                            hintText:
                            'User will Write any content here. it is optional'),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  buildDivider() {
    return Divider(
      color: Colors.black12,
      thickness: 1,
      height: 1,
    );
  }

  buildSingleTile(icon, heading, onPressed, buttonText) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: red,
              size: 30,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              heading,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.black54),
            ),
          ],
        ),
      ),
      subtitle: RadientFlatButton(buttonText, Colors.red, onPressed),
    );
  }


}
