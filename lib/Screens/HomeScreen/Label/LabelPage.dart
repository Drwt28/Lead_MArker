import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_olx/Screens/HomeScreen/Label/CustomerListPage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_olx/Api/ApiClient.dart';
import 'package:flutter_olx/CustomWidgets/Button.dart';
import 'package:flutter_olx/CustomWidgets/Label.dart';
import 'package:flutter_olx/CustomWidgets/TextField.dart';
import 'package:flutter_olx/CustomWidgets/style.dart';
import 'package:flutter_olx/Model/Label.dart';
import 'package:flutter_olx/Model/UserData.dart';
import 'package:flutter_olx/Provider/User.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LabelPage extends StatefulWidget {
  User user;

  LabelPage();

  @override
  _LabelPageState createState() => _LabelPageState();
}

class _LabelPageState extends State<LabelPage> {
  var labels = List();
  ApiClient apiClient = ApiClient();

  @override
  void initState() {
    super.initState();

  }
  List<Customer> customers = [];
  List<AddedLabel> customerlabelList = [];
  List<AddedLabel> leadslabelList = [];

  var fetched = false;


  @override
  Widget build(BuildContext context) {
   labels = Provider.of<UserDataProvider>(context).labelList;
   customers = List.castFrom(Provider.of<UserDataProvider>(context).totalCustomers);
  customerlabelList = Provider.of<UserDataProvider>(context).userData.customerAddedLabels;
  leadslabelList = Provider.of<UserDataProvider>(context).userData.leadsAddedLabel;
    return Scaffold(
      body: (labels != null)
          ? (labels.length > 0)
              ? ListView(
        scrollDirection: Axis.vertical,
                  children: List.generate(
                      labels.length,
                      (index) => BuildSingleLabelItem(
                          labels[index] ,calculateCustomers(labels[index]),index)))
              : Center(
                  child: RadientFlatButton('Add label', red, () {
                    _openColorPicker();
                  }),
                )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: red,
        heroTag: 'color',
        onPressed: () {
          _openColorPicker();
        },
        child: Icon(Icons.add),
      ),
    );
  }


  showOptionDialog(label){
    return AlertDialog(
      title: Text('Are you sure to delete'),
      actions: [
        RadientFlatButton('No', Colors.black, (){
          Navigator.pop(context);
        }),
        RadientGradientButton(context, 34.0, 70.0, ()async{
          Navigator.pop(context);

          labels.remove(label);
          setState(() {
          });
          await apiClient.deleteLabel(label);

        Provider.of<UserDataProvider>(context,listen: false).getLabelList();



        }, 'Yes')
      ],
    );
  }

  BuildSingleLabelItem(AddedLabel label,cust,index,
      {onpressed, onlongPressed}) {

    try {
      Color lColor = Color(int.parse(label.color));
    } catch (e) {}
    return Card(
      child: ListTile(
        onTap: () {

          List<Customer> localCustomer = calculateCustomers(label)??[];
          Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerListPage(label.id)));
        },
        onLongPress: () {
          showDialog(context: context,child: showOptionDialog(label));
        },
       leading: RadientLabel(label.color, label.labelName),
        trailing: Text(' ${cust.length} Customers '),
      ),
    );
  }

  var labelController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return Form(
          key: formKey,
          child: AlertDialog(
            contentPadding: const EdgeInsets.all(6.0),
            title: RadientTextField('New Label Name', labelController, '',requestFocus: true),
            content: content,
            actions: [
              FlatButton(
                child: Text('Cancel'),
                onPressed: Navigator.of(context).pop,
              ),
              FlatButton(
                child: Text('Submit'),
                onPressed: () async {
                  var label = AddedLabel(
                  labelName:labelController.text.trim(),
                  color :_selectedColor.value.toString(),
                      );
                  labels.add(label);
                  setState(() {});
                  Navigator.pop(context);
                  apiClient.insertLabel(label);
                  Provider.of<UserDataProvider>(context).getLabelList();


                  setState(() {});

                },
              ),
            ],
          ),
        );
      },
    );
  }

  Color _selectedColor = red;

  void _openColorPicker() async {
    _openDialog(
      "Accent Color picker",
      MaterialColorPicker(
        colors: materialColors,
        selectedColor: _selectedColor,
        onMainColorChange: (color) => setState(() => _selectedColor = color),
        circleSize: 40.0,
        spacing: 10,
      ),
    );
  }

  calculateCustomers(AddedLabel label) {
    List<Customer> localdata=[];
    int count = 0;
    var customerLabels =  customerlabelList;

    customerLabels.addAll(leadslabelList);


    customerlabelList = customerlabelList.where((element) => (element.labelId==label.labelId)).toList();

    for(var custLabel in customerLabels)
      {



        for(var temp in customers)
          {
            if(temp.id==custLabel.cusLeadId&&custLabel.labelId==label.labelId)
              {
                if(!localdata.contains(temp))
                  localdata.add(temp);
              }
          }

      }


    return localdata;

  }




}
