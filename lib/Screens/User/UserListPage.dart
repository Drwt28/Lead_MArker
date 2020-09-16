import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_olx/CustomWidgets/SingleUserModel.dart';
import 'package:flutter_olx/CustomWidgets/Utils.dart';
import 'package:flutter_olx/Model/UserData.dart';
import 'package:flutter_olx/Screens/User/UserDetailScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class UserListPage extends StatefulWidget {
  List<SubUser> user ;

  UserListPage(this.user);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User List"),
      ),
      body: SingleChildScrollView(
        child: buildDataTable(),
        scrollDirection: Axis.horizontal,
      )
    );
  }

  buildDataTable() {
    return DataTable(
      columns: [
        DataColumn(label:buildHeadText("Name") ),
        DataColumn(label: buildHeadText("Mobile No")),
        DataColumn(label: buildHeadText("Details")),
      ],
      rows: List.generate(widget.user.length, (index) => buildSingletableRow(widget.user[index]))
    );
  }

  buildSingletableRow(SubUser user){
    return DataRow(cells: [
      DataCell(buildSingleText(makeTitleString(user.username))),
      DataCell(buildSingleText(user.phoneNo)),
      DataCell(FittedBox(
        fit: BoxFit.fill,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(context, CupertinoPageRoute(
                  builder: (context)=>SubUserDetailScreen(user)
                ));
              },
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.green,
                size: 18,
              ),
            ),
            IconButton(
              onPressed: () {
                try {
                  launch("tel: +91 ${user.phoneNo}");
                } catch (e) {
                  print(e);
                }
              },
              icon: Icon(
                Icons.call,
                color: Colors.blue,
                size: 18,
              ),
            ),
          ],
        ),
      )),
    ]
    );

  }

  buildSingleText(String text) {
    return Text(
      text,
      style:
          Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.black),
    );
  }  
  
  buildHeadText(String text) {
    return Text(text,style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black,fontSize: 16));
  }
}
