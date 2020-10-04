import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_olx/CustomWidgets/Button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_olx/Api/ApiClient.dart';
import 'package:flutter_olx/CustomWidgets/TextField.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MultiUserform extends StatefulWidget {
  @override
  _MultiUserformState createState() => _MultiUserformState();
}

enum Role{
  SelectRole,
  AccountOwner,Manager,L1User,L2User
}
class _MultiUserformState extends State<MultiUserform> {

  ApiClient apiClient = ApiClient();
  Role selectedRole = Role.SelectRole;
  String name,email,phone,password,role;
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        bottom: PreferredSize(
          child:  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Submit Details for Registration',style: TextStyle(color: Colors.white),textAlign: TextAlign.start,),
          ),
          preferredSize: Size.fromHeight(40),
        ),
        title: Text('Multi User'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: ()async{
              loading = true;
              setState(() {

              });
              createSubUser();
                            setState(() {
                loading = false;
              });
            },
          )
        ],
      ),

      body: loading?Center(child: CircularProgressIndicator(),):Stack(
        children: [
//          Image.asset('images/Icons/bg.jpg',height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,
//            fit: BoxFit.cover,),
          ListView(
            scrollDirection: Axis.vertical,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadientTextField('Full Name', nameController, '',onChanged: (val){
                  name = val;
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadientTextField('Business Email', emailController, '',onChanged: (val){
                  email = val;
                }),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadientTextField('Mobile No', phoneController, '',onChanged: (val){
                  phone = val;
                },inputType: TextInputType.number),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadientTextField('No of Employees', new TextEditingController(), '',onChanged: (val){
                  password = val.toString().trim();
                },inputType: TextInputType.numberWithOptions()),
              )             , Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadientTextField('Business Name', passwordController, '',onChanged: (val){
                  password = val.toString().trim();
                }),
              ),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: RadientGradientButton(context,50.0,100.0,(){
                  createSubUser();
                },"Submit",isLoading: loading),
              )

              ],
          ),
        ],
      ),

    );
  }


createSubUser()async {
    Provider.of<UserDataProvider>(context,listen: false).approveSingleUser();
    await showDialog(context: context,child: AlertDialog(
      title: Text("Congrats..."),
      content: Text("you got 18 days free trial for the Team Management"),
      actions: [
        FlatButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Ok"))
      ],
    ));

    Navigator.pop(context);

   }
}
