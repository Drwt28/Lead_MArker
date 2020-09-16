// import 'package:contacts_service/contacts_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_olx/Api/ApiClient.dart';
// import 'package:flutter_olx/Model/UserData.dart';
// import 'package:flutter_olx/Provider/UserDataProvider.dart';
// import 'package:provider/provider.dart';
//
// class ImportDeviceContactPage extends StatefulWidget {
//   bool isCustomer;
//
//
//   ImportDeviceContactPage(this.isCustomer);
//
//   @override
//   _ImportDeviceContactPageState createState() =>
//       _ImportDeviceContactPageState();
// }
//
// class _ImportDeviceContactPageState extends State<ImportDeviceContactPage>
//     with AutomaticKeepAliveClientMixin {
//   List<bool> isSelected;
//   List<Contact> selectedContacts = List();
//   List<Contact> contactList;
//   var loading = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getContacts();
//   }
//
//   ApiClient apiClient = ApiClient();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Select Contacts'),
//
//           actions: [
//             IconButton(
//               onPressed: (){
//                 showDialog(context: context,child: AlertDialog(
//
//                   title: Text("Are you sure to Import"),
//                   actions: [
//
//                     FlatButton(onPressed: ()async{
//                       Navigator.pop(context);
//                       setState(() {
//                       loading = true;
//                       });
//                       for(var con in selectedContacts)
//                         {
//                          await apiClient.createCustomer(Customer(company: con.company??'',
//                          email: con.emails.toList()??'',
//                            address: con.postalAddresses??'',
//                            name: con.displayName??'',
//                            phoneNo: con.phones.toList(),
//
//                          ));
//                         }
//
//                       setState(() {
//                         loading=false;
//                       });
//                       await Provider.of<UserDataProvider>(context,listen: false).getUserData();
//                     }, child: Text("import")),
//                     FlatButton(onPressed: (){
//                       Navigator.pop(context);
//                     }, child: Text("cancel")),
//                   ],
//                 ));
//               },
//               icon: Icon(Icons.check_circle,color: Colors.white,),
//
//             )
//           ],
//         ),
//         body: !(contactList == null||loading)
//             ? ListView.builder(
//             itemCount: contactList.length ?? 0,
//             itemBuilder: (context, index) =>
//             (contactList[index].displayName == null)
//                 ? SizedBox()
//                 : ListTile(
//               trailing: isSelected[index]
//                   ? Icon(
//                 Icons.check_circle,
//                 color: Colors.green,
//               )
//                   : SizedBox(),
//               title: Text(contactList[index].displayName ?? ''),
//               onTap: () {
//                 isSelected[index] = !isSelected[index];
//                 if (isSelected[index]) {
//                   selectedContacts.add(contactList[index]);
//                 } else {
//                   selectedContacts.remove(contactList[index]);
//                 }
//                 setState(() {});
//               },
//             ))
//             : Center(
//           child: CircularProgressIndicator(),
//         ));
//   }
//
//   Future<Iterable<Contact>> getContacts() async {
//     print('called');
//     Iterable<Contact> contacts = await ContactsService.getContacts();
//     print(contacts.toString());
//     contactList = contacts.toList();
//     isSelected = List.generate(contacts.toList().length, (index) => false);
//
//     setState(() {});
//   }
//
//   @override
//   // TODO: implement wantKeepAlive
//   bool get wantKeepAlive => true;
// }