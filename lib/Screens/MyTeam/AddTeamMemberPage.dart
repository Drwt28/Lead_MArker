import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_olx/Api/ApiClient.dart';
import 'package:flutter_olx/CustomWidgets/TextField.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTeamMemberPage extends StatefulWidget {
  @override
  _AddTeamMemberPageState createState() => _AddTeamMemberPageState();
}

enum Role{
  SelectRole,
  AccountOwner,Manager,L1User,L2User
}
class _AddTeamMemberPageState extends State<AddTeamMemberPage> {

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
        title: Text('Add User'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: ()async{
              loading = true;
              setState(() {

              });

              var data = await apiClient.CreateSubUser(name.trim(), phone.trim(), password.trim(), email.trim(), '', role);
              Provider.of<UserDataProvider>(context,listen: false).getUserData();
              if(data is String)
                {
                  showDialog(context: context,child: AlertDialog(
                    title: Icon(Icons.info,color: Colors.red,),
                    content: Text(data),
                    actions: [
                     FlatButton(
                       child: Text('ok'),
                       onPressed: (){
                         Navigator.pop(context);
                         loading= false;
                         setState(() {

                         });
                       },
                     )
                    ],
                  ));
                }
              else{
                print(data.toString());
              }

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
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadientTextField('Password', passwordController, '',onChanged: (val){
                  password = val.toString().trim();
                }),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Select Role',style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black54),),
              )

              ,
               buildSingleTile('Account Owner', Role.AccountOwner),
               buildSingleTile('Manager', Role.Manager),
               buildSingleTile('L1 User', Role.L1User),
               buildSingleTile('L2 User', Role.L2User),
            ],
          ),
        ],
      ),

    );
  }

  buildSingleTile(String tit,Role r){
    return ListTile(
      title:  Text(tit,style: TextStyle(color: Colors.black),),
      leading: Radio(
        activeColor: Colors.red,
        value: r,
        groupValue: selectedRole,
        onChanged: (Role value) {
          setState(() {
            selectedRole = value;
            role = tit;
          });
        },
      ),
    );
  }
}
