import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_olx/Screens/SearchCustomerPage/SearchCustomerPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_olx/CustomWidgets/style.dart';
import 'package:flutter_olx/Model/UserData.dart';
import 'package:flutter_olx/Provider/User.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';
import 'package:flutter_olx/Screens/LoginPage.dart';

import 'package:flutter_olx/Screens/MyBussinessPage.dart';
import 'package:flutter_olx/Screens/MyTeam/AddTeamMemberPage.dart';
import 'package:flutter_olx/Screens/Share/InOutPage.dart';
import 'package:flutter_olx/Screens/Share/recievedList.dart';
import 'package:flutter_olx/Screens/User/BussinessNameScreen.dart';
import 'package:flutter_olx/Screens/User/UserListPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Customers/CustomersPage.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_olx/Screens/HomeScreen/Label/LabelPage.dart';
import 'package:flutter_olx/Screens/HomeScreen/Lead/LeadPage.dart';
import 'package:flutter_olx/Screens/HomeScreen/Task/TaskPage.dart';

import 'package:flutter_olx/Screens/MyTeam/MyTeamPage.dart';

import 'Import/ImportLeadCustomer.dart';




class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  UserData _userData = UserData(customer: [],customerAddedLabels: [],leads: [],leadsAddedLabel: [],message: '',subUsers: [],userList: []);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final titles = ['Leads','Customers','Labels','My Team','Tasks'];


  @override
  void initState() {
    super.initState();
    Provider.of<UserDataProvider>(context,listen: false).getUserData();
    Provider.of<UserDataProvider>(context,listen: false).getBusinessDetails();

  }


  @override
  Widget build(BuildContext context) {
    _userData = Provider.of<UserDataProvider>(context).userData;
    return Scaffold(
      drawer: buildDrawer(_userData.subUsers),
      key: scaffoldKey,
      appBar: buildAppBar(titles[selectedIndex]),
      body: IndexedStack(
        index: selectedIndex,
        children:[
          LeadPage(leads: _userData.leads,labelList: _userData.leadsAddedLabel,),
          CustomersPage(labelList: _userData.customerAddedLabels,)
          ,LabelPage(),
          MyBussinespage()
          ,TaskPage()

        ],
      ),

      bottomNavigationBar: BuildBottomNavigationBar(),
    );
  }


  Widget buildAppBar(String title) {

    var customers = Provider.of<UserDataProvider>(context).totalCustomers;
    var permission = Provider.of<UserDataProvider>(context).userPermission;

    return AppBar(
      title: Text(title),
      backgroundColor: red,
      leading: IconButton(
        onPressed: (){
         if( !scaffoldKey.currentState.isDrawerOpen)
           scaffoldKey.currentState.openDrawer();
        },
        icon: Icon(Icons.menu),
      ),
      actions: [
      IconButton(icon: Icon(Icons.search),
      onPressed: (){
        showSearch(context: context, delegate: SearchCustomerPage(customers:customers));
      },),
      IconButton(icon: Icon(Icons.share),onPressed: (){},),
      permission.canImport?IconButton(icon: Icon(Icons.more_vert),onPressed: (){
        showMenuDialog();
      },):Icon(Icons.lock),

      ],
    );
  }

  int selectedIndex=0;
  Widget BuildBottomNavigationBar(){
    return BottomNavigationBar(

      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: red,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      elevation: 8,
      currentIndex: selectedIndex,
      onTap: (index){
        selectedIndex = index;
        setState(() {

        });
      },
      items: [
BuildSingleNavBarItem('Leads', 'images/Icons/icon-leads.png','images/Icons/leads.png' ),
BuildSingleNavBarItem('Customers', 'images/Icons/customers-red.png','images/Icons/customers.png' ),
BuildSingleNavBarItem('Labels', 'images/Icons/labels-red.png','images/Icons/labels.png' ),
BuildSingleNavBarItem('Bussiness', 'images/Icons/my-business-red.png','images/Icons/my-business.png' ),
BuildSingleNavBarItem('Tasks', 'images/Icons/task-red.png','images/Icons/task.png',counter: "2" ),

      ],
    );
  }



  // buildCurvedNavigationBar(){
  //   return CurvedNavigationBar(
  //     animationDuration: Duration(milliseconds: 500),
  //     color: red,
  //     height: 50,
  //     buttonBackgroundColor: red,
  //     backgroundColor: Colors.white,
  //     index: selectedIndex,
  //     onTap: (index){
  //       selectedIndex = index;
  //       setState(() {
  //
  //       });
  //     },
  //     items: [
  //
  //       Image.asset('images/Icons/icon-leads.png',width: 24,height: 24,color: Colors.white,),
  //       Image.asset('images/Icons/customers-red.png',width: 27,height: 27,color: Colors.white),
  //       Image.asset('images/Icons/labels-red.png',width: 27,height: 27,color: Colors.white),
  //       Image.asset('images/Icons/my-business-red.png',width: 27,height: 27,color: Colors.white),
  //
  //
  //     ],
  //   );
  // }

   BuildSingleNavBarItem(title,selectedImage,image,{counter}){
    return BottomNavigationBarItem(
      activeIcon:Image.asset(selectedImage,width: 27,height: 27,) ,
      title: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(title),
      ),
      icon: Stack(
        overflow: Overflow.visible,
        children: [

          Image.asset(image,width: 27,height: 27,),
          (counter==null)?SizedBox():Positioned(
            top: -4,
            right: -4,
            child: Container(
              height: 18,
              width: 18,
              child: Center(child: Text(counter??'',style: TextStyle(color :Colors.white),)),
              decoration: BoxDecoration(
                  color: red,
                  shape: BoxShape.circle
              ),
            ),
          )
        ],
      )
    );
  }

  buildDrawer(List<SubUser> Subusers){
    var permission = Provider.of<UserDataProvider>(context).userPermission;
    var businessDetails = Provider.of<UserDataProvider>(context).businessDetails;
    return Drawer(

      elevation: 10,
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    child: Center(
                      child: (businessDetails.logo!=null)?SizedBox():InkWell(
                          onTap: (){},
                          child: Text('Add Logo')),
                    ),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(businessDetails.logo),
                        alignment: Alignment.center,
                        fit: BoxFit.cover
                      ),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.green,width: 1,style: BorderStyle.solid)
                    ),

                  ),
                ),
                ListTile(
                  title:Column(
                    children: [
                      Text(businessDetails.name??'',style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.black),),
                      Text(businessDetails.email??'',style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.black87),),
                    ],
                  ),

                  trailing: IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>BusinessNameScreen()));
                    },
                    icon: Icon(Icons.edit,color: Colors.green,),
                  ),

                ),
              ],
            ),


          ),
          Divider(
            height: .8,
            color: Colors.grey,
            thickness: .8,

          ),
          permission.canAddUser?buildInOutExpainsion():ListTile(
            title: Text("Share/Recieved Lead"),
            leading: Icon(Icons.lock,color : Colors.red),
          ),
          permission.canAddUser?buildExpandableDrawerItem():ListTile(
    title: Text("Add User"),
    leading: Icon(Icons.lock,color : Colors.red)),
          ListTile(
            leading: Icon(Icons.supervisor_account,color: red,),
            title: Text('My Team',style: TextStyle(color: red),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>MyTeamPsge()
              ));
            },
          ),
          //buildSingleDrawerItem('images/Icons/customers-red.png','Customers',(){} ),
//          buildSingleDrawerItem('images/Icons/labels-red.png','Labels',(){} ),
//          buildSingleDrawerItem('images/Icons/task-red.png','Tasks',(){} ),
//          buildSingleDrawerItem('images/Icons/my-business-red.png','My Business',(){} ),

          Divider(
            height: .5,
            color: Colors.grey,
            thickness: .5,

          ),

          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
          ),
          ListTile(
            onTap: ()async{
              Provider.of<UserDataProvider>(context,listen: false).LogOut();
              Navigator.pushReplacement(context, CupertinoPageRoute(
                  builder: (context)=>LoginPage()
              ));
            },
            leading: Icon(Icons.power_settings_new),
            title: Text('Log Out'),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Contact Us'),
          )

        ],
      ),
    );
  }

  buildSingleDrawerItem(image,text,onpressed){
    return ListTile(
      onTap: onpressed,
      title: Text(text),
      leading: Image.asset(image,height: 24,width: 24,),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<User>(context).getUser();
//    Provider.of<UserDataProvider>(context).getUserData();

  }


  buildExpandableDrawerItem() {


      return ExpansionTile(
        leading: Image.asset("images/Icons/customers.png",height: 24,width: 24,),

        title: Text("User "),
        initiallyExpanded: false,
        children: [
          ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>UserListPage(_userData.subUsers)
              ));
            },
            title: Text("User List",),
            leading: Icon(Icons.menu,color: red,),
          )
          ,ListTile(
            onTap: (){


              Navigator.push(context, MaterialPageRoute(
                builder: (context)=>AddTeamMemberPage()
              ));

            }
            ,
            title: Text("Add User"),
            leading: Icon(Icons.add,color: red,),
          )
        ],
      );

  }

  buildInOutExpainsion() {

      return ExpansionTile(
        leading: Icon(Icons.assignment),
        title: Text("Shared Lead/Customer"),
        initiallyExpanded: false,
        children: [
          ListTile(
            onTap: ()async{
             await handlePermissions();
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ReceivedListPage()));
            },
            title: Text("Received"),
            leading: Icon(Icons.arrow_drop_down,color: red,),
          )
          ,ListTile(
            onTap: ()async{
             await  handlePermissions();
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SentCusLeadPage()));
            }
            ,
            title: Text("Shared"),
            leading: Icon(Icons.arrow_drop_up,color: red,),
          )
        ],
      );

  }

  Future<bool> handlePermissions() async {
    var status = await Permission.contacts.request();

    return status.isGranted;
  }

  var _animationListState = GlobalKey<AnimatedListState>();

  showMenuDialog(){
    showDialog(context: context,child: AlertDialog(
      title: Text("Import from contacts"),
      content: Wrap(

        children: [
          ListTile(
            onTap: (){

              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ImportDeviceContactPage(true)));
            },
            title: Text("In Customers",style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black),),
          ),ListTile(
            onTap: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ImportDeviceContactPage(false)));
            },
            title: Text("In leads",style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black)),
          )
        ],
      ),
      actions: [
        FlatButton(
          child: Text("Cancel"),
          onPressed: (){
            Navigator.pop(context);
          },
        )
      ],
    ));
  }
}
