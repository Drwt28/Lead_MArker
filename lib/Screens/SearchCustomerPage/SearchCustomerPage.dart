import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_olx/CustomWidgets/CustomerLeadModel.dart';
import 'package:flutter_olx/Model/UserData.dart';

class SearchCustomerPage extends SearchDelegate {
  List customers;

  SearchCustomerPage({this.customers});

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.navigate_before),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var temp = customers
        .where((element) =>
            element.name
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            element.company
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();

    return (temp.length == 0)
        ? Center(
            child: Text(
              "No Result",
              style: Theme.of(context).textTheme.headline6,
            ),
          )
        : ListView(
            children: List.generate(
                temp.length,
                (index) => Card(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        title: Text(temp[index].name),
                        subtitle: Text(temp[index].company),
                      ),
                    )),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var temp = customers
        .where((element) =>
            element.name
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            element.company
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();
    ;
    return (temp.length == 0)
        ? Center(
            child: Text(
              "No Result",
              style: Theme.of(context).textTheme.headline6,
            ),
          )
        : ListView(
            children: List.generate(
                temp.length,
                (index) => Card(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        title: Text(temp[index].name),
                        subtitle: Text(temp[index].company),
                      ),
                    )),
          );
  }
}
