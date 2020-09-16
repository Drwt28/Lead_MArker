import 'package:flutter/material.dart';
import 'package:flutter_olx/Api/ApiClient.dart';
import 'package:flutter_olx/CustomWidgets/Utils.dart';
import 'package:flutter_olx/Model/CustomerLabelModel.dart';
import 'package:flutter_olx/Model/UserData.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerListPage extends StatefulWidget {


  String labelId;


  CustomerListPage(this.labelId);

  @override
  _CustomerListPageState createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {


  CustomerLabelModel customerLabelModel;
  List customers = [];


  ApiClient apiClient = ApiClient();
  @override
  void initState() {
    super.initState();
    getData();

  }

  @override
  Widget build(BuildContext context) {
    customers = Provider.of<UserDataProvider>(context).totalCustomers;
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer List"),
      ),

      body: (customerLabelModel==null)?Center(child: CircularProgressIndicator(),):(customerLabelModel.cutstomers.length>0)?ListView.builder(
          itemCount: customerLabelModel.totalCustomers,
          itemBuilder: (context,index)=>buildSingleTile(index)):Center(child: Text("No Customers"),),
    );
  }


  buildSingleTile(index)
  {

    String id  = customerLabelModel.cutstomers[index].cusLeadId;

    Customer customer = customers.firstWhere((element) =>element.id==id);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 3,horizontal: 6),
      child: ListTile(
        leading: IconButton(
          onPressed: (){
            launch("+91 ${customer.phoneNo[0].toString()}");
          },
          icon: Icon(Icons.call,color: Colors.red,),
        ),
        title:Text(makeTitleString(customer.name),style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black),),
        subtitle: Column(
          children: [
            Text(customer.email.toString(),style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.black87),),
            SizedBox(height: 3,),
            Text(customer.company,style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.black54),),
            SizedBox(height: 3,),
            Text(customer.userType,style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.black38),),
          ],
        ),

      ),
    );
  }


  getData()async {
   customerLabelModel =  await apiClient.getLabelCustomers(widget.labelId);
  }
}
