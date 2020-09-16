import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_olx/CustomWidgets/Button.dart';
import 'package:flutter_olx/CustomWidgets/TextField.dart';
import 'package:flutter_olx/Model/BusinessDetails.dart';
import 'package:flutter_olx/Provider/User.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';
import 'package:flutter_olx/Screens/HomeScreen/HomePage.dart';

class BusinessNameScreen extends StatefulWidget {
  BusinessNameScreen();

  @override
  _BusinessNameScreenState createState() => _BusinessNameScreenState();
}

class _BusinessNameScreenState extends State<BusinessNameScreen> {
  BusinessDetails businessDetails;

  @override
  void initState() {
    super.initState();

    getData();
  }

  var loading = true;

  getData() async {
    await Provider.of<UserDataProvider>(context, listen: false)
        .getBusinessDetails();
    businessDetails =
        Provider.of<UserDataProvider>(context, listen: false).businessDetails;
    if (businessDetails != null) {
      print('updateUI');
      updateUi();
    }

    setState(() {
      loading = false;
    });
  }

  var update = false;
  var bnameController = TextEditingController();
  var bDescriptionController = TextEditingController();
  var bAddressController = TextEditingController();
  var bTimingController = TextEditingController();
  var bContactController = TextEditingController();
  var bEmailController = TextEditingController();
  var image;
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    businessDetails = Provider.of<UserDataProvider>(context).businessDetails;
    return Form(
      key: formkey,
      child: Scaffold(
          body: Stack(
        overflow: Overflow.clip,
        children: [
          Image.asset(
            'images/Icons/bg.jpg',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          loading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Enter Your Business Details',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RadientTextFieldWhite(
                          'Business Name', bnameController, ''),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RadientTextFieldWhite(
                          'Business Description', bDescriptionController, ''),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RadientTextFieldWhite(
                          'Business Address', bAddressController, ''),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RadientTextFieldWhite(
                          'Business Timings', bTimingController, ''),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RadientTextFieldWhite(
                          'Business Contact no.', bContactController, ''),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RadientTextFieldWhite(
                          'Business Email', bEmailController, ''),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(businessDetails.logo)
                            ),
                              color: Colors.white, shape: BoxShape.circle),
                          child: FloatingActionButton(
                            elevation: 0,
                            backgroundColor: Colors.white70,
                            child: (logo == null)
                                ? Center(
                                    child: Text(
                                    'Click me',
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                  ))
                                : Image(
                                    image: MemoryImage(logo),
                                    fit: BoxFit.cover,
                                  ),
                            onPressed: () {
                              updateLogo();
                            },
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              updateLogo();
                            },
                            child: Text(
                              'Upload Business Logo',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(color: Colors.white),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 50,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                update
                                    ? Align(
                                        alignment: Alignment.center,
                                        child: RadientGradientButton(
                                            context, 48.0, 150.0, () async {
                                          loading = true;
                                          setState(() {});
                                          if (formkey.currentState.validate()) {
                                            businessDetails = BusinessDetails(
                                                bnameController.text.trim(),
                                                bDescriptionController.text
                                                    .trim(),
                                                bAddressController.text.trim(),
                                                bTimingController.text.trim(),
                                                bContactController.text.trim(),
                                                bEmailController.text.trim(),
                                                '');
                                            Provider.of<UserDataProvider>(
                                                    context,
                                                    listen: false)
                                                .updateBusinessDetails(
                                                    businessDetails);
                                            Navigator.pop(context);
                                          }
                                        }, 'Update'),
                                      )
                                    : Align(
                                        alignment: Alignment.center,
                                        child: RadientGradientButton(
                                            context, 48.0, 150.0, () async {
                                          loading = true;
                                          setState(() {});
                                          if (formkey.currentState.validate()) {
                                            businessDetails = BusinessDetails(
                                                bnameController.text.trim(),
                                                bDescriptionController.text
                                                    .trim(),
                                                bAddressController.text.trim(),
                                                bTimingController.text.trim(),
                                                bContactController.text.trim(),
                                                bEmailController.text.trim(),
                                                '');
                                            Provider.of<UserDataProvider>(
                                                    context,
                                                    listen: false)
                                                .updateBusinessDetails(
                                                    businessDetails);
                                            Navigator.pop(context);
                                            loading = false;
                                          }

                                          //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                                        }, 'Next'),
                                      )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ],
      )),
    );
  }

  updateUi() {
    bAddressController.text = businessDetails.address;
    bContactController.text = businessDetails.contactno;
    bDescriptionController.text = businessDetails.description;
    bnameController.text = businessDetails.name;
    bTimingController.text = businessDetails.timing;
    bEmailController.text = businessDetails.email;
    update = true;
    setState(() {});
  }

  Uint8List logo;

  updateLogo() async {
    // logo =File.fromRawPath(await (await ImagePicker().getImage(source: ImageSource.gallery)).readAsBytes());

    var file = await ImagePicker()
        .getImage(maxHeight: 200, maxWidth: 200, source: ImageSource.gallery);

    logo = await file.readAsBytes();

    Provider.of<UserDataProvider>(context, listen: false)
        .updateBusinessLogo(file);

    setState(() {});
  }
}
