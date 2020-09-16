import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_olx/Model/RecievedList.dart';
import 'package:flutter_olx/Model/UserData.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';

class ReceivedListPage extends StatefulWidget {
  ReceivedListPage();

  @override
  _ReceivedListPageState createState() => _ReceivedListPageState();
}

class _ReceivedListPageState extends State<ReceivedListPage> {
List<ApprovedList> approvedList;
List<Customer> customersList;


@override
  void initState() {
  super.initState();
  Provider.of<UserDataProvider>(context,listen: false).getRecievedLeadCusList();
  }

  @override
  Widget build(BuildContext context) {
  approvedList = List.castFrom(Provider.of<UserDataProvider>(context).receivedCusLeadList);
  customersList = List.castFrom(Provider.of<UserDataProvider>(context).totalCustomers);
  print(approvedList.length);

    return Scaffold(
      appBar: AppBar(
        title: Text("Received Lead/Customer"),
      ),
      body: approvedList==null?Center(child: CircularProgressIndicator()):approvedList.length==0?Center(
        child: Text("No Lead Received"),
    ):ListView.builder(
          itemCount: approvedList.length,
          itemBuilder: (context,index)=>buildSingleItem(approvedList[index])),
    );
  }

  buildSingleItem(ApprovedList approved) {
  return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(
          approved.receiveStatus,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(fontSize: 17, color: Colors.black),
        ),
        subtitle: Text("Type " + approved.receiveStatus,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontSize: 15, color: Colors.black)),
        trailing: IconButton(
                onPressed: () {
                  Provider.of<UserDataProvider>(context,listen: false).approveLeadCust(approved.id);
                showDialog(context: context,child: AlertDialog(
                  content: Text('Approved request successfully sent'),
                  title: Icon(Icons.watch_later),
                  actions: [
                    FlatButton(
                      child: Text('ok'),
                      onPressed: (){Navigator.pop(context);},
                    )
                  ],
                ));
                },
                iconSize: 32,
                icon: Icon(
                  Icons.check_circle,
                  color: Colors.red,
                ),
              ),
      ),
    );
  }
}
