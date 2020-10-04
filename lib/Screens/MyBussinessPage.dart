import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_olx/Api/ApiClient.dart';
import 'package:flutter_olx/CustomWidgets/style.dart';
import 'package:flutter_olx/Screens/Document/DocumentListPage.dart';
import 'package:flutter_olx/Screens/PriceProposal/PriceProposalList.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_olx/CustomWidgets/Button.dart';
import 'package:flutter_olx/Model/BusinessDetails.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';
import 'package:flutter_olx/Screens/MyTeam/MyTeamPage.dart';
import 'package:share/share.dart';
import 'User/BussinessNameScreen.dart';

class MyBussinespage extends StatefulWidget {
  @override
  _MyBussinespageState createState() => _MyBussinespageState();
}

class _MyBussinespageState extends State<MyBussinespage> {
  @override
  Widget build(BuildContext context) {
    BusinessDetails businessDetails =
        Provider.of<UserDataProvider>(context).businessDetails;
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: .5)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        trailing: InkWell(
                          onTap: (){
                            updateLogo();
                          },
                          child: Container(
                            child: Center(
                                child: InkWell(
                                  onTap: () {

                                  },
                                )),
                            height: 77,
                            width: 60,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(businessDetails.logo),
                                    alignment: Alignment.center,
                                    fit: BoxFit.cover),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.black54,
                                    width: 1,
                                    style: BorderStyle.solid)),
                          ),
                        ),
                        leading: (businessDetails.name.isEmpty)
                            ? RadientGradientButton(
                                context,
                                45.0,
                                130.0,
                                () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              BusinessNameScreen()));
                                },
                                'Add Details',
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    businessDetails.name ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(color: Colors.black),
                                  ),
                                  Text(
                                    businessDetails.email ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .copyWith(color: Colors.black87),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        trailing: OutlineButton(
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          highlightedBorderColor: Colors.green,
                          onPressed: () {
                            final RenderBox box = context.findRenderObject();
                            Share.share(
                                'Bossiness Name  ${businessDetails.name} \n'
                                'Business Email ${businessDetails.email} \n'
                                'Business Phone ${businessDetails.contactno} '
                                'Business Address\n ${businessDetails.address} \n',
                                subject: 'My Bossiness Details',
                                sharePositionOrigin:
                                    box.localToGlobal(Offset.zero) & box.size);
                          },
                          color: Colors.green,
                          textColor: Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              'Share our bussiness profile',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                        leading:
                            RadientFlatButton('Edit Details', Colors.green, () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => BusinessNameScreen()));
                        }),
                      ),
                    )
                  ],
                ),
              ),
              // buildSingleItem('Companies', 'images/Icons/company.png', () {}),
              buildSingleItem(' Share Documents', 'images/Icons/notes.png', () {
                Navigator.push(context, MaterialPageRoute
                  (
                    builder: (context)=>DocumentListPage()
                ));
              }),
              buildSingleItem(
                  'Price Proposals', 'images/Icons/invoice.png', () {
                    Navigator.push(context, MaterialPageRoute
                      (
                      builder: (context)=>PriceProposalList()
                    ));
              }),

          Card(
            child: ListTile(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyTeamPsge()));
              },
              leading:Icon(Icons.people,color: red,size: 34,) ,
              title: Text(
                "My Team",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(fontWeight: FontWeight.w800, color: Colors.black),
              ),
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }

  buildSingleItem(String title, image, onPressed) {
    return Card(
      child: ListTile(
        onTap: onPressed,
        leading: Image.asset(
          image,
          height: 34,
          width: 34,
        ),
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .subtitle1
              .copyWith(fontWeight: FontWeight.w800, color: Colors.black),
        ),
      ),
    );
  }

  File logo;
  var api = ApiClient();

  updateLogo() async {
    // logo =File.fromRawPath(await (await ImagePicker().getImage(source: ImageSource.gallery)).readAsBytes());

    var file = await ImagePicker()
        .getImage(maxHeight: 200, maxWidth: 200, source: ImageSource.gallery);

    Provider.of<UserDataProvider>(context, listen: false)
        .updateBusinessLogo(file);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Provider.of<UserDataProvider>(context, listen: false).getBusinessDetails();
  }
}
