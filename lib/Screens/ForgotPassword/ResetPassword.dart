import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_olx/CustomWidgets/Button.dart';
import 'package:flutter_olx/CustomWidgets/TextField.dart';
import 'package:flutter_olx/Screens/LoginPage.dart';
import 'package:http/http.dart' as http;

class ResetPassword extends StatefulWidget {
  String userId;


  ResetPassword(this.userId);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var loading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        bool dec;
       await showDialog(context: context,child: AlertDialog(
          title: Text("Are you sure to exit"),
          actions: [
            FlatButton(onPressed: (){
              Navigator.pop(context);
              dec =  true;
            }, child: Text("Quit")),
            FlatButton(onPressed: (){
              Navigator.pop(context);
              dec =  false;
            }, child: Text("Continue"))
          ],
        ));
       return dec;
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: [
            Image.asset(
              'images/Icons/bg.jpg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .36,
                  child: Center(
                      child: Text(
                        'Reset Password',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(color: Colors.white),
                      )),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Enter Your Email Id',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  RadientTextFieldDense('Enter Password', passwordController, ''),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RadientTextFieldDense('Confirm Password', confirmPasswordController, '',
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // RadientFlatButton('Resend OTP', Colors.yellow, () {}),
                      RadientGradientButton(context, 48.0, 150.0, () {
                        resetPassword();
                      }, "Reset", isLoading: loading)
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }


  verifyOtp(String password) async {

    loading = true;
    setState(() {});
    print({'password': password,'id': widget.userId}.toString());
    try {
      var url =
          'http://radient.appnitro.co/api/reset-password';
      var response = await http.post(url, body: {'password': password,'id': widget.userId});
      var data = JsonDecoder().convert(response.body);
      print(data);
      if (data['status']) {
        setState(() {
          loading = false;
        });

        showDialog(context: context,child: AlertDialog(
          title: Text("Password Reset Successfully"),
          actions: [
            FlatButton(onPressed: (){
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
            }, child: Text("Login"),)
          ],
        ));

      } else {
        loading = false;
        setState(() {});
        showDialog(context: context,child: AlertDialog(
          title: Text("Some error occurred"),
          actions: [
            FlatButton(onPressed: (){
              Navigator.pop(context);

            }, child: Text("Retry"),)
          ],
        ));

      }
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
      });
    }
  }


  resetPassword()
  {
    if(validate())
      {
          verifyOtp(passwordController.text.trim());
      }
    else{
      showDialog(context: context,child: AlertDialog(
        title: Text("Password not match"),
        actions: [
          FlatButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Retry"),)
        ],
      ));
    }

  }

  bool validate()
  {
    if(confirmPasswordController.text.trim().contains(passwordController.text.trim()))
      {
        return true;
      }
    else{
      return false;
    }
  }
}
