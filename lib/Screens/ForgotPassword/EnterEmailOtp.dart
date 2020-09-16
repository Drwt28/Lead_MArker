import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_olx/Api/ApiClient.dart';
import 'package:flutter_olx/Screens/ForgotPassword/ResetPassword.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:flutter_olx/CustomWidgets/Button.dart';
import 'package:flutter_olx/CustomWidgets/TextField.dart';
import 'package:flutter_olx/CustomWidgets/style.dart';
import 'package:flutter_olx/Provider/User.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_olx/Screens/HomeScreen/HomePage.dart';
import 'package:flutter_olx/Screens/LoginPage.dart';

class EmailOtpPage extends StatefulWidget {
  // String id, phone_no;
  //
  // var otpController = TextEditingController();
  //
  // EmailOtpPage(this.id, this.phone_no);

  @override
  _EmailOtpPageState createState() => _EmailOtpPageState();
}

class _EmailOtpPageState extends State<EmailOtpPage> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  var timer = "";
  String userId;

  var otpController = TextEditingController();
  var emailController = TextEditingController();
  var loading = false;
  var formkey = GlobalKey<FormState>();

  startTimer() async {
    // for (int i = 240; i > 0; i--) {
    //   var min = i / 60;
    //   var sec = (min.floor() + 1) * 60 - min * 60;
    //   sec = 60 - sec;
    //
    //   timer = "${min.floor()} : ${sec.floor()}";
    //   await Future.delayed(Duration(milliseconds: 1000));
    //
    //   setState(() {});
    }

    // showResendOtpDialog('Your OTP expired');



  showResendOtpDialog(message) {
    showDialog(
        context: context,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(message),
          actions: [
            RadientFlatButton('cancel', red, () {
              Navigator.pop(context);
            })
          ],
        ));
  }

  sendOtp(String email_id) async {

    loading = true;
    setState(() {});
    try {
      var url =
          'http://radient.appnitro.co/api/forgot-password';
      var response = await http.post(url, body: {'email_id': email_id});
      var data = JsonDecoder().convert(response.body);
      print(data);
      if (data['status']) {
        isOtp = true;
        setState(() {
          loading = false;
        });
        // User user = User();
        // User.saveUser(response).then((value) => Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => HomePage())));
      } else {
        loading = false;
        setState(() {});
        showResendOtpDialog("incorrect OTP");
      }
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
      });
    }
  }

  verifyOtp(String otp) async {

    loading = true;
    setState(() {});
    try {
      var url =
          'http://radient.appnitro.co/api/verify-otp';
      var response = await http.post(url, body: {'enter_otp': otp});
      var data = JsonDecoder().convert(response.body);
      print(data);
      if (data['status']) {
        setState(() {
          loading = false;
        });
        userId = data['data']['id'];
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ResetPassword(
            userId
        )));


        // User.saveUser(response).then((value) => Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => HomePage())));
      } else {
        loading = false;
        setState(() {});
        showResendOtpDialog(data.toString());
      }
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
      });
    }
  }

  bool isOtp = false;

   Future<void> saveUser(Response response) async {

     {
      var data = (JsonDecoder().convert(response.body));
      print(data);
      if(data['status'])
        {
          userId = data['id'];
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ResetPassword(
            userId
          )));
        }


    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<User>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: formkey,
        child: Stack(
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
                    'Forgot Password',
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
                      RadientTextFieldDense('Enter mail Id', emailController, ''),
                ),
                Visibility(

                  visible: isOtp,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RadientTextFieldDense('Enter OTP', otpController, '',
                        type: TextInputType.numberWithOptions()),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: Text(
                      timer,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // RadientFlatButton('Resend OTP', Colors.yellow, () {}),
                      RadientGradientButton(context, 48.0, 150.0, () {
                          isOtp?verifyOtp(otpController.text.trim()):sendOtp(emailController.text.trim());
                      }, isOtp?'Verify':"SendOtp", isLoading: loading)
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
}
