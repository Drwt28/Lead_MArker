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

  TeamMembersListPage({this.team, this.index});

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

    showDialog(
        context: context,
        child: StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(
              "Select User",
              style: Theme.of(context).textTheme.headline6,
            ),
            actions: [
              FlatButton(
                child: Text('Done'),
                onPressed: () async {
                  Navigator.pop(context);
                  await apiClient.addUsertoTeam(
                      widget.team, customers[selectedIndex]);
                  getTeamMembersList();
                },
              ),
            ],
            content: Container(
              height: 300,
              width: 250,
              child: ListView.builder(
                shrinkWrap: true,
                itemExtent: 60,
                itemBuilder: (context, index) => buildSingleSelectTile(
                    customers[index], index, selected, setState),
                itemCount: customers.length,
              ),
            ),
          ),
        ));
  }

  var selectedIndex = -1;

  Widget buildSingleSelectTile(SubUser customer, index, selected, setstate) {
    return RadioListTile(
      groupValue: selectedIndex,
      value: index,
      onChanged: (val) {
        setState(() {
          selectedIndex = index;
        });
        setstate(() {});
      },
      title: Text(customer.username),
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
      body: Center(
        child: (teamMembers == null)
            ? CircularProgressIndicator()
            : teamMembers.length == 0
                ? RadientGradientButton(
                    context, 50.0, MediaQuery.of(context).size.width * .7, () {
                    addingTeam = true;
                    setState(() {});
                  }, 'Add Team Member')
                : ListView.builder(
                    itemCount: teamMembers.length,
                    itemBuilder: (context, index) => Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          child: ListTile(
                            title: Text(teamMembers[index].name +
                                "(${teamMembers[index].email})"),
                            subtitle: Text(teamMembers[index].role),
                            onTap: () {},
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

  @override
  void initState() {
    super.initState();
    getTeamMembersList();
  }

  getTeamMembersList() async {
    teamMembers = await Provider.of<UserDataProvider>(context, listen: false)
        .getTeamMembers(widget.index);
    setState(() {});
  }
}
