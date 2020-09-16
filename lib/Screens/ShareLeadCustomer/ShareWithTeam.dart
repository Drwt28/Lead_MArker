import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_olx/CustomWidgets/Button.dart';
import 'package:flutter_olx/Model/UserData.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';
import 'package:flutter_olx/Screens/MyTeam/TeamMembersListPage.dart';
import 'package:flutter_olx/Screens/ShareLeadCustomer/ShareWithMemberList.dart';

class ShareWithTeam extends StatefulWidget {
  Customer customer;

  ShareWithTeam(this.customer);

  @override
  _ShareWithTeamState createState() => _ShareWithTeamState();
}

class _ShareWithTeamState extends State<ShareWithTeam> {

  var teams = [];
  @override
  Widget build(BuildContext context) {

    teams = Provider.of<UserDataProvider>(context).teams;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Team'),
      ),
      body: ListView.builder(
          itemCount: teams.length,
          itemBuilder: (context,index)=>BuildSingleTeamPage(teams[index].name??'', (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ShareWithMemberList(team: teams[index],index:index,customer:widget.customer,)));
          }, teams[index].members==null?0:teams[index].members.length,index)),
    );
  }

  BuildSingleTeamPage(teamname,onpressed,members,index){
    return ListTile(
      onLongPress: (){
        showDialog(context: context,child:         AlertDialog(
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
