import 'package:flutter/material.dart';
import 'package:flutter_olx/Api/ApiClient.dart';
import 'package:flutter_olx/CustomWidgets/Utils.dart';
import 'package:flutter_olx/CustomWidgets/style.dart';
import 'package:flutter_olx/DetailScreen.dart';
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

      body: (customerLabelModel==null)?Center(child: CircularProgressIndicator(),):(customerLabelModel.labelList.length>0)?ListView.builder(
          itemCount: customerLabelModel.totalRows,
          itemBuilder: (context,index)=>buildSingleTile(index)):Center(child: Text("No Customers"),),
    );
  }


  buildSingleTile(index)
  {

    String id  = customerLabelModel.labelList[index].cusLeadId;

    Customer customer = customers.firstWhere((element) =>element.id==id);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4,horizontal: 6),
      child: ListTile(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>detailScreen(customer: customer,isCustomer: true,labels: [],lead: customer,)));
        },
        leading: FloatingActionButton(
          onPressed: (){
            launch("+91 ${customer.phoneNo[0].toString()}");
          },
          mini: true,
          elevation: 0,
          backgroundColor: red,
          heroTag: index.toString(),
          child: Icon(Icons.phone,color: Colors.white,),
        ),
        title:Text(makeTitleString(customer.name),style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black,fontSize: 17),),
        subtitle: Column(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Text(customer.email.toString().replaceFirst("]", "").replaceFirst("[", ""),style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.black87),)),
            SizedBox(height: 3,),
            Align(
                alignment: Alignment.centerRight,child: Text(customer.company,style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.black54),)),
            SizedBox(height: 3,),
            Align(
                alignment: Alignment.bottomRight,
                child: Text(customer.userType,style: Theme.of(context).textTheme.subtitle2.copyWith(color: red),)),
          ],
        ),

      ),
    );
  }


  getData()async {
   customerLabelModel =  await apiClient.getLabelCustomers(widget.labelId);
   setState(() {

   });
  }
}
