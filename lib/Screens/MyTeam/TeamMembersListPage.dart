import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_olx/Api/ApiClient.dart';
import 'package:flutter_olx/CustomWidgets/Button.dart';
import 'package:flutter_olx/Model/Team.dart';
import 'package:flutter_olx/Model/TeamMember.dart';
import 'package:flutter_olx/Model/UserData.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';
import 'package:flutter_olx/Screens/MyTeam/AddTeamMemberPage.dart';

class TeamMembersListPage extends StatefulWidget {
  Team team;
  int index;

  TeamMembersListPage({this.team,this.index});

  @override
  _TeamMembersListPageState createState() => _TeamMembersListPageState();
}

class _TeamMembersListPageState extends State<TeamMembersListPage> {
  List subUsers = List();
  List<TeamMember> teamMembers;
  var apiClient = ApiClient();

  PersistentBottomSheetController _controller;

  Widget buildSelectUserWidget(List customers) {
    List<bool> selected = List.generate(customers.length, (index) => false);
   return Card(
      margin: EdgeInsets.all(10),
      child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                Center(
                  child: RadientGradientButton(

              context,50.0,MediaQuery.of(context).size.width*.5,()async {

                  setState(() {
                  addingTeam = false;
                  });
                    await apiClient.addUsertoTeam(
                        widget.team, customers[selectedIndex]);
                    getTeamMembersList();
//          Provider.of<UserDataProvider>(context,listen: false).getTeamList();
                  },'Add to team'
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 100,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height-100,child: ListView.builder(
                      itemExtent: 60,
                      itemBuilder: (context, index) =>  buildSingleSelectTile(customers[index], index, selected),
                      itemCount: customers.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  var selectedIndex = -1;

  Widget buildSingleSelectTile(SubUser customer, index, selected) {
    return ListTile(
      leading: Radio(
        groupValue: selectedIndex,
        value: index,
        onChanged: (val) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      title: Text(customer.username + "\t${customer.emailId}"),
      subtitle: Text(customer.role),
    );
  }

  var scaffold = GlobalKey<ScaffoldState>();

  var addingTeam = false;

  @override
  Widget build(BuildContext context) {
    subUsers = Provider.of<UserDataProvider>(context).userData.subUsers;
    return Scaffold(
      key: scaffold,
      body: addingTeam?buildSelectUserWidget(subUsers):Center(
        child: (teamMembers==null)?CircularProgressIndicator():teamMembers.length==0?RadientGradientButton(context, 50.0, MediaQuery.of(context).size.width*.7, (){

          addingTeam = true;
          setState(() {

          });

        }, 'Add Team Member'):ListView.builder(
            itemCount: teamMembers.length,
            itemBuilder: (context,index)=>Card(
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
          child: ListTile(
            title: Text(teamMembers[index].name+"(${teamMembers[index].email})"),
            subtitle: Text(teamMembers[index].role),
            onTap: (){

            },
          ),
        )),
      ),
      appBar: AppBar(
        title: Text(widget.team.name),
        actions: [
          IconButton(
            onPressed: () {
              buildSelectUserWidget(subUsers);
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
    );
  }

  var expanded = [false, false];

  BuildSingleTile(var exp) {
    return ExpansionPanel(
        isExpanded: exp,
        headerBuilder: (context, val) => ListTile(
              leading: Image.asset(
                'images/Icons/customers-red.png',
                height: 30,
                width: 30,
              ),
              title: Text('Naveen (GritFusion)'),
              subtitle: Column(
                children: [
                  Text('Label'),
                  Text('23 March 20202 Price Proposal #100/')
                ],
              ),
            ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                color: Colors.green,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.orange,
              ),
              onPressed: () {},
            ),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    getTeamMembersList();
  }

  getTeamMembersList()async{
  teamMembers = await  Provider.of<UserDataProvider>(context,listen: false).getTeamMembers(widget.index);
  setState(() {

  });
  }
}
