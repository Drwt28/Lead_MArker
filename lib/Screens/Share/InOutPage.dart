import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_olx/Model/RecievedList.dart';
import 'package:flutter_olx/Model/UserData.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';

class SentCusLeadPage extends StatefulWidget {


  @override
  _SentCusLeadPageState createState() => _SentCusLeadPageState();
}

class _SentCusLeadPageState extends State<SentCusLeadPage> {



  List<ApprovedList> sentList;
  List<Customer> customersList;
  @override
  Widget build(BuildContext context) {
    sentList = List.castFrom(Provider.of<UserDataProvider>(context).sentCustLeadList);
    customersList = List.castFrom(Provider.of<UserDataProvider>(context).totalCustomers);
    return Scaffold(
      appBar: AppBar(
        title: Text("Shared Customers/Lead"),
      ),
      body: sentList==null?Center(child: CircularProgressIndicator()):sentList.length==0?Center(
        child: Text("No Lead Received"),
      ):ListView.builder(
          itemCount: sentList.length,
          itemBuilder: (context,index)=>buildSingleItem(sentList[index])),
    );
  }

  buildSingleItem(ApprovedList approved) {
   return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(
          "Share on (${approved.date.toString()})",
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(fontSize: 17, color: Colors.black),
        ),
        subtitle: Text("status " + approved.receiveStatus,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontSize: 15, color: Colors.black)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<UserDataProvider>(context,listen: false).getSentCusLead();
  }
}
