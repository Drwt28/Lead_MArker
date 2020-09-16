import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_olx/CustomWidgets/Utils.dart';
import 'package:flutter_olx/CustomWidgets/style.dart';
import 'package:provider/provider.dart';
import 'package:flutter_olx/Model/UserData.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';
import 'package:flutter_olx/Screens/HomeScreen/Task/AddTaskPage.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}



class _TaskPageState extends State<TaskPage> {

  List<Task> tasks = List();
  List customers = List();

  buildSingleTile(Task task,List customers){

    Customer  customer = Customer();
    String name,phone;
    print(task.cust_lead_id);
    if(customers.length>0)
      {
      try{
        customer = customers.firstWhere((element) =>(element.id==task.cust_lead_id));
      }
      catch(e)
    {
      customer = Customer();
    }
      }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text("${makeTitleString(customer.name)??""}",style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black,fontSize: 18),),
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
                child: Text('"${task.description}"',style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black87,fontSize: 17)),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text("Added on " + getDate(task.date.toString()),style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.black54)),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var customers = Provider.of<UserDataProvider>(context).totalCustomers;
    var tasks = Provider.of<UserDataProvider>(context).userData.userTasks;
    return Scaffold(
      body:!(tasks.length>0&&customers.length>0)?Center(child: CircularProgressIndicator(),):
      ListView.builder(itemBuilder: (context,index)=>buildSingleTile(tasks[index], customers),itemCount: tasks.length,),
      floatingActionButton: FloatingActionButton(
        backgroundColor: red,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTaskPage(selected: -1,)));
        },
        heroTag: 'ass',

      ),
    );
  }
}
