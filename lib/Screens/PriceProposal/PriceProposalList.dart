import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_olx/CustomWidgets/Utils.dart';
import 'package:flutter_olx/CustomWidgets/style.dart';
import 'package:flutter_olx/Model/PriceProposal.dart';
import 'package:flutter_olx/Model/UserData.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';
import 'package:flutter_olx/Screens/PriceProposal/CreatePriceProposal.dart';
import 'package:flutter_olx/Screens/PriceProposal/ViewPriceProposal.dart';
import 'package:provider/provider.dart';

class PriceProposalList extends StatefulWidget {




  @override
  _PriceProposalListState createState() => _PriceProposalListState();
}

class _PriceProposalListState extends State<PriceProposalList> {
  List<PriceProposal> priceProposalList= [];

  @override
  void initState() {
    super.initState();
    Provider.of<UserDataProvider>(context,listen: false).getPriceProposal();
  }

  List customers = [];

  @override
  Widget build(BuildContext context) {

    priceProposalList = Provider.of<UserDataProvider>(context).priceProposalList;
    customers = Provider.of<UserDataProvider>(context).totalCustomers;


    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, CupertinoPageRoute(
            builder: (context)=>CreatePricePosal()
          ));
        },
        child: Icon(Icons.add),
        backgroundColor: red,
      ),
      appBar: AppBar(
        title: Text("Price Proposals"),
      ),
      body: (priceProposalList==null)?Center(
        child: CircularProgressIndicator(),
      ):priceProposalList.length>0?ListView.builder(itemBuilder: (context,index)=>BuildSingleTile(priceProposalList[index],context),
      itemCount: priceProposalList.length,):
          Center(child: Text("No Proposals yet",style: Theme.of(context).textTheme.headline6,),)
    );
  }

  BuildSingleTile(PriceProposal priceProposal,context) {

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
      child: ListTile(
        onTap: (){
          var customer = Customer();
          try{
            customer = customers.firstWhere((element) => (priceProposal.custLeadId==element.id));
          }catch(e)
          {

          }
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=>ViewPriceProposal(priceProposal, customer)));
        },
        title: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text("${makeTitleString(priceProposal.custLeadName)??""}",style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black,fontSize: 18),),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('"${priceProposal.description}"',style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black87,fontSize: 17)),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text("Added on " + getDate(priceProposal.date.toString()),style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.black54)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
