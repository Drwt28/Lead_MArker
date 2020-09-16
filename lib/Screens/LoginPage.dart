import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_olx/Screens/ForgotPassword/EnterEmailOtp.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:flutter_olx/CustomWidgets/Button.dart';
import 'package:flutter_olx/CustomWidgets/TextField.dart';
import 'package:flutter_olx/CustomWidgets/style.dart';
import 'package:flutter_olx/Provider/User.dart';
import 'package:flutter_olx/Screens/ConfirmOtpPage.dart';
import 'package:flutter_olx/Screens/HomeScreen/HomePage.dart';
import 'package:flutter_olx/Screens/SignUpScreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var loginId = TextEditingController(), password = TextEditingController();
  var formKey = GlobalKey<FormState>();


  var loading = true;
  var isLogged = false;
  checkForLogin()async{
    var shared = await SharedPreferences.getInstance();
    var tokken = shared.getString('token');
    print(tokken);
    if(tokken==null)
      {
      loading = false;
      }
    else{
      loading = false;
      isLogged = true;
    }
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
  checkForLogin();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        color: Colors.white,
        child: loading?AlertDialog(
            content: Text("Loading...",style: Theme.of(context).textTheme.headline6,textAlign: TextAlign.center,),
            title : Center(child: CircularProgressIndicator(),
            )):(isLogged)?HomePage():Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Form(
            key: formKey,
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'images/Icons/bg.jpg',
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                      Center(
                          child: Text(
                            'Login',
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(color: Colors.white),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 150.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: MediaQuery.of(context).size.height * .6,
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: ListView(
                          children: [
                            RadientTextField('Email Id', loginId, ''),
                            RadientTextField('Password', password, ''),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 50.0, right: 50.0),
                              child: RadientGradientButton(context, 50.0,
                                  MediaQuery.of(context).size.width * .8, () {
//                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ConfirmOtpPage()));
                                    if (formKey.currentState.validate())
                                      LoginUser(
                                          loginId.text.trim(), password.text.trim());

                                  }, 'Login',isLoading: loading),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: RadientFlatButton(
                                      'Forgot Password', Colors.blue[800], () {
                                        Navigator.push(context, MaterialPageRoute(
                                          builder: (context)=>EmailOtpPage()
                                        ));
                                  })),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            RadientFlatButton(
                                "Don't Have Account", Colors.black54, () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen()));
                            }),
                            RadientFlatButton('Sign Up Here', Colors.blue[800], () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen()));
                            })
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String loginUrl = 'http://radient.appnitro.co/api/users/login';
  LoginUser(String id, String password) async {

    try{

      loading = true;
      setState(() {

      });
      var response =
      await http.post(loginUrl, body: {'email_id': id, 'password': password});
      var data = JsonDecoder().convert(response.body);

      if(data['status']){
        await User.saveUser(response);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      }
      else{
        showErrorDialog(data['message']);
      }

    }catch(e){
      showErrorDialog(e.toString());
    }
  }

  showErrorDialog(text){
    loading = false;
    setState(() {

    });
    showDialog(context: context,child: AlertDialog(
      title: Icon(Icons.error,color: Colors.red,size: 40,),
      content: Text(text),
      actions: [
        RadientFlatButton('Ok', red, (){
          Navigator.pop(context);
        })
      ],
    ));
  }
}
