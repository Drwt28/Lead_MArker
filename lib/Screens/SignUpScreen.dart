import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_olx/CustomWidgets/Button.dart';
import 'package:flutter_olx/CustomWidgets/TextField.dart';
import 'package:flutter_olx/Screens/ConfirmOtpPage.dart';
import 'package:flutter_olx/Screens/LoginPage.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {


  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var mobileController = TextEditingController();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  var loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: formKey,
        child: Stack(
          children: [
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 2,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('images/Icons/bg.jpg', height: MediaQuery
                      .of(context)
                      .size
                      .height / 2, width: MediaQuery
                      .of(context)
                      .size
                      .width,
                    fit: BoxFit.cover,)
                  , Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom :100.0),
                        child: Text('SignUp', style: Theme
                            .of(context)
                            .textTheme
                            .headline4
                            .copyWith(color: Colors.white),),
                      )
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: Align(

                alignment: Alignment.center,
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * .67,
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        RadientTextField('Full Name', nameController, '')
                        ,
                        RadientTextField('Mobile No', mobileController, '',
                            inputType: TextInputType.number)
                        ,
                        RadientTextField('email', emailController, '',
                            inputType: TextInputType.emailAddress),
                        RadientTextField('Password', passwordController, ''),
                        Padding(
                          padding: const EdgeInsets.only(top: 8,left : 60.0,right: 60.0),
                          child: RadientGradientButton(context, 50.0, MediaQuery
                              .of(context)
                              .size
                              .width * .8, () {
                            if (formKey.currentState.validate())
                              SignUp(nameController.text.trim(),
                                  mobileController.text.trim(),
                                  passwordController.text.trim(),
                                  emailController.text.trim());
                          }, 'Signup',isLoading: loading),
                        ),

                        RadientFlatButton(
                            "Don't Have Account", Colors.black54, () {}),
                        RadientFlatButton('Login Here', Colors.blue[800], () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => LoginPage()));
                        },)
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  SignUp(name, mobile, pass, email) async {
    loading = true;
    var data;
    setState(() {
    });
    try{
      var url = 'http://radient.appnitro.co/api/User_registration/insertUser';
      var response = await http.post(url, body: {
        'email_id': email,
        'phone_no': mobile,
        'password': pass,
        'username': name,
        'created_by':'',
        'user_type':'Admin',
        'role':'',

      });
      data = JsonDecoder().convert(response.body);


      if(data['status']) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ConfirmOtpPage(data['userData']['id'],data['userData']['phone_no'])));
      }
    }catch(e){
      showAlerDialog(data.toString());
      setState(() {
        loading = false;
      });
    }



  }

  showAlerDialog(String message){
    showDialog(context: context,child: AlertDialog(
      elevation: 0,
      title: Text(message),
      actions: [
        RadientGradientButton(context,30.0, 60.0, (){
          Navigator.pop(context);
        },'ok')
      ],
    ));
  }
}
