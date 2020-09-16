import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_olx/Api/ApiClient.dart';
import 'package:flutter_olx/CustomWidgets/Button.dart';
import 'package:flutter_olx/CustomWidgets/TextField.dart';
import 'package:flutter_olx/CustomWidgets/style.dart';
import 'package:flutter_olx/Model/Lead.dart';
import 'package:flutter_olx/Model/UserData.dart';
import 'package:flutter_olx/Provider/User.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EditCustomerPage extends StatefulWidget {
  Customer customer;


  EditCustomerPage(this.customer);

  @override
  _EditCustomerPageState createState() => _EditCustomerPageState();
}

class _EditCustomerPageState extends State<EditCustomerPage> {




  String _id,_tokken;
  ApiClient apiClient = new ApiClient();
  var formkey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var companyController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var addressController = TextEditingController();

  List<String> phoneList = [];
  List<String> emailList = [];
  var loading = false;
  var dec = false;
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Form(
      key: formkey,
      child: WillPopScope(
        onWillPop: ()async{
          Navigator.pop(context,dec);
          return true;
        },
        child: Hero(
          tag: 'add lead',
          child: Scaffold(
            appBar: AppBar(
              title: Text('Edit '),
            ),

            body: ListView(
              scrollDirection: Axis.vertical,
              children: [
//                MultiTextField('phone',(){}),


                RadientTextFieldImage('images/Icons/customers-red.png', 'Add Name',
                    nameController, ''),
                RadientTextFieldImage(
                    'images/Icons/company.png', 'Company', companyController, ''),
                MultiTextField('Phone',(val){
                  phoneList = val;

                },'images/Icons/CALL.png',phoneList),
                MultiTextField('Email',(val){
                  emailList = val;
                },'images/Icons/company.png',emailList),
                RadientTextFieldImage('images/Icons/NAVIGATION.png', 'Add Address',
                    addressController, ''),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 90, right: 90),
                  child: RadientGradientButton(
                      context, 50.0, MediaQuery.of(context).size.width * 0.6,
                          () async {
                        if (formkey.currentState.validate()) {
                          loading = true;
                          setState(() {

                          });
                          var status = await apiClient.updateCustomerLead(new Customer(
                            id: widget.customer.id,
                            userType: widget.customer.userType,
                            phoneNo: phoneList,name: nameController.text,address: addressController.text,email: emailList,company: companyController.text,));
                         print(status);
                          Provider.of<UserDataProvider>(context,listen: false).getUserData();
                          showDialog(context: context,child: AlertDialog(
                            title: Icon(Icons.error,color: Colors.red,),
                            content: Text(status),
                            actions: [
                              RadientFlatButton('Ok', Colors.green, (){

                                Navigator.pop(context);
                                Navigator.pop(context);
                              })
                            ],
                          ));
                          loading = false;
                          setState(() {

                          });
                        }
                      }, 'Edit', isLoading: loading),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    updateUi();
    super.initState();
  }

  void updateUi() {
    Customer customer = widget.customer;

    addressController.text = customer.address;
    companyController.text = customer.company;
    phoneList = List.castFrom(customer.phoneNo);
    emailList = List.castFrom(customer.email);
    nameController.text = customer.name;

    setState(() {

    });

  }
}

class MultiTextField extends StatefulWidget {
  String hint;
  String image;
  var onValueChanged;
  List<String> initialList;


  MultiTextField(this.hint, this.onValueChanged,this.image,this.initialList);

  @override
  _MultiTextFieldState createState() => _MultiTextFieldState();
}

class _MultiTextFieldState extends State<MultiTextField> {
  List<String> values = [];


  @override
  void initState() {
    super.initState();
    initList();
  }

  initList(){
    values = List.castFrom(widget.initialList);
    print(values.length);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: IconButton(icon: Icon(Icons.add,color: Colors.red,size: 40,),onPressed: (){

        values.add("");
        setState(() {

        });
      },
      ),
      title: ListView.builder(
          itemCount: values.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context,index)=>Container(
            margin: EdgeInsets.only(left: 10),
            width: MediaQuery.of(context).size.width,
            child: TextFormField(
              initialValue: values[index],
              validator: (value) => value.isEmpty?'Enter ${widget.hint}':null,

              onChanged: (val){
                values[index] = val.trim();
                widget.onValueChanged(values);
              },
              decoration: InputDecoration(
                  icon: Image.asset(widget.image,width: 25,height: 25,),
                  hintStyle: TextStyle(color: Colors.black54,),
                  suffixIcon:(index==0)?Container(height: 0,width: 0,): IconButton(
                    icon: Icon(Icons.delete,color: Colors.red,),
                    onPressed: (){
                      values.removeAt(index);
                      setState(() {
                      });
                    },
                  ),
                  hintText: widget.hint

              ),
            ),
          )),


    );
  }
}
