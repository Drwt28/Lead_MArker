import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_olx/Api/ApiClient.dart';
import 'package:flutter_olx/CustomWidgets/CustomerLeadModel.dart';
import 'package:flutter_olx/CustomWidgets/Utils.dart';
import 'package:flutter_olx/Model/UserData.dart';

class SubUserDetailScreen extends StatefulWidget {
  SubUser subUser;

  SubUserDetailScreen(this.subUser);

  @override
  _SubUserDetailScreenState createState() => _SubUserDetailScreenState();
}

class _SubUserDetailScreenState extends State<SubUserDetailScreen> {
  int currentIndex = 0;

  buildSingleTab(title) {
    return BottomNavigationBarItem(icon: Icon(Icons.title), title: Text(title));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subUser.username,
        ),
      ),
      body: buildDataTable((currentIndex == 0) ? lead : customers),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (val) {
          setState(() {
            currentIndex = val;
          });
        },
        items: [
          buildSingleTab('Leads'),
          buildSingleTab('Customer'),
          buildSingleTab('Tasks'),
        ],
      ),
    );
  }

  buildDataTable(lead) {
    return (lead == null)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : (lead.length == 0)
            ? Center(
                child: Text(
                  'No Data',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.red),
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    dividerThickness: 2,
                    showCheckboxColumn: true,
                    columns: [
                      DataColumn(label: buildHeadText("Name")),
                      DataColumn(label: buildHeadText("E-mail")),
                      DataColumn(label: buildHeadText("Mobile")),
                      DataColumn(label: buildHeadText("Company")),
                    ],
                    rows: List.generate(lead.length,
                        (index) => buildSingletableRow(lead[index]))),
              );
  }
  buildTaskPage() {
    return (task == null)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : (lead.length == 0)
            ? Center(
                child: Text(
                  'No Data',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.red),
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    dividerThickness: 2,
                    showCheckboxColumn: true,
                    columns: [
                      DataColumn(label: buildHeadText("Task Date")),
                      DataColumn(label: buildHeadText("Name")),
                      DataColumn(label: buildHeadText("Date")),
                    ],
                    rows: List.generate(lead.length,
                        (index) => buildSingletableRow(lead[index]))),
              );
  }

  buildSingletableRow(Customer customer) {
    return DataRow(cells: [
      DataCell(buildSingleText(makeTitleString(customer.name.toString()))),
      DataCell(buildSingleText(makeTitleString(customer.email.toString()))),
      DataCell(buildSingleText(customer.phoneNo.toString())),
      DataCell(buildSingleText(makeTitleString(customer.company.toString()))),
    ]);
  }
  buildSingleTaskRow(Task customer) {


    return DataRow(cells: [
      DataCell(buildSingleText(makeTitleString(customer.description.toString()))),
      DataCell(buildSingleText(getDate((customer.remainderDate.toString())))),
      DataCell(buildSingleText(customer.remainderDate.toString())),

    ]);
  }

  buildSingleText(String text) {
    return Text(
      text,
      style:
          Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.black),
    );
  }

  buildHeadText(String text) {
    return Text(text,
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(color: Colors.black, fontSize: 16));
  }

  List<Customer> customers;
  List<Customer> lead;

  List task = [];
  ApiClient apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    UserData userData = await apiClient.getSubuserData(widget.subUser.id);

    customers = userData.customer;
    lead = userData.leads;
    task = userData.userTasks;

    setState(() {});
  }
}
