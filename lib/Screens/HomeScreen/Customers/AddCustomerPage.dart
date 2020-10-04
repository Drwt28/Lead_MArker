import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_olx/Api/ApiClient.dart';
import 'package:flutter_olx/CustomWidgets/Button.dart';
import 'package:flutter_olx/CustomWidgets/TextField.dart';
import 'package:flutter_olx/Model/Customers.dart';
import 'package:flutter_olx/Model/UserData.dart';
import 'package:flutter_olx/Provider/User.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_olx/Provider/UserDataProvider.dart';
import 'package:flutter_olx/Screens/HomeScreen/Lead/AddLeadPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCustomerPage extends StatefulWidget {
  @override
  _AddCustomerPageState createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  var formkey = GlobalKey<FormState>();
  ApiClient apiClient = ApiClient();
  var nameController = TextEditingController();
  var companyController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var addressController = TextEditingController();
  var loading = false;
  var dec = false;
  var phone,email;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pop(context,dec);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Customer'),
        ),
        body: ListView(
          children: [
            RadientTextFieldImage('images/Icons/customers-red.png', 'Add Name',
                nameController, '',isValidate: true),
            RadientTextFieldImage(
                'images/Icons/company.png', 'Company', companyController, '',isValidate: false),
            MultiTextField('Phone',(val){
              phone = val;
            },'images/Icons/CALL.png'),
            MultiTextField('Email',(val){
              email = val;
            },'images/Icons/company.png'),
            RadientTextFieldImage('images/Icons/NAVIGATION.png', 'Add Address',
                addressController, ''),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 90, right: 90),
              child: RadientGradientButton(
                  context, 50.0, MediaQuery.of(context).size.width * 0.6,
                      () async {
                        {
                          loading = true;
                          setState(() {

                          });
                          var status = await insertCustomer(Customer(email:email,address: addressController.text,name: nameController.text,phoneNo: phone ,company: companyController.text));

                          loading = false;
                          setState(() {

                          });
                        }
                      }, 'Create', isLoading: loading),
            )
          ],
        ),
      ),
    );
  }

  String _id,_tokken;
  Future<String> insertCustomer(Customer customer) async {

     var status = await apiClient.createCustomer(customer);
    Provider.of<UserDataProvider>(context,listen: false).getUserData();

     showDialog(context: context,child: AlertDialog(
       title: Icon(Icons.error,color: Colors.red,),
       content: Text("Created Successfully"),
       actions: [
         RadientFlatButton('Ok', Colors.green, (){
           Navigator.pop(context);
           Navigator.pop(context);
         })
       ],
     ));

    return status;
  }

}
