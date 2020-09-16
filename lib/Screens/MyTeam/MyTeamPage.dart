import 'package:flutter/material.dart';
import 'package:flutter_olx/CustomWidgets/Utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_olx/Api/ApiClient.dart';
import 'package:flutter_olx/CustomWidgets/Button.dart';
import 'package:flutter_olx/CustomWidgets/style.dart';
import 'package:flutter_olx/Model/Team.dart';
import 'package:flutter_olx/Model/UserData.dart';
import 'package:flutter_olx/Provider/User.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';
import 'package:flutter_olx/Screens/MyTeam/TeamMembersListPage.dart';

class MyTeamPsge extends StatefulWidget {
  User user;


  MyTeamPsge();

  @override
  _MyTeamPsgeState createState() => _MyTeamPsgeState();
}

class _MyTeamPsgeState extends State<MyTeamPsge> {


  @override
  void initState() {
    super.initState();
  }

  ApiClient apiClient = ApiClient();
  var list=  ['Developer','Designer'];
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  List teams = List();


  @override
  Widget build(BuildContext context) {
    teams = Provider.of<UserDataProvider>(context).teams;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Team'),
      ),
      body: ListView.builder(
          itemCount: teams.length,
          itemBuilder: (context,index)=>BuildSingleTeamPage(makeTitleString(teams[index].name)??'', (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TeamMembersListPage(team: teams[index],index:index)));
      }, teams[index].members==null?0:teams[index].members.length,index)),
      floatingActionButton: FloatingActionButton(
          heroTag: 'as',
        child: Icon(Icons.add),
        backgroundColor: red,
        onPressed: (){

          showDialog(context: context,child: Form(
            key: formKey,
            child: AlertDialog(
              title: Text('Enter Team Name'),
              content: TextFormField(
                validator: (val)=>val.isEmpty?'enter team name':null,
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Enter name'
                ),

              ),
              actions: [
                RadientFlatButton(  'Cancel',Colors.red,(){
                  Navigator.pop(context);
                },),
                RadientGradientButton(context, 40.0, 70.0, ()async{
                   if(formKey.currentState.validate()){
                     Navigator.pop(context);
                     var status = await apiClient.addTeam(nameController.text.trim());
                     Provider.of<UserDataProvider>(context,listen: false).getTeamList();
                     print(status);
                   }
                }, 'Create')
              ],
            ),
          ));
        },
      ),
    );
  }


  BuildSingleTeamPage(teamname,onpressed,members,index){
    return ListTile(
      onLongPress: (){
      showDialog(context: context,child:AlertDialog(
        title: Text('Are you sure to delete'),
        actions: [
          RadientFlatButton('No', Colors.black, (){
            Navigator.pop(context);
          }),
          RadientGradientButton(context, 34.0, 70.0, ()async{
            Navigator.pop(context);
            setState(() {
            });;

            Provider.of<UserDataProvider>(context,listen: false).deleteTeam(index);


          }, 'Yes')
        ],
      ));
      },
      onTap: onpressed,
      trailing: Text('$members Members'),
      leading: Text(teamname,style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black),),
    );
  }


}
