import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_olx/CustomWidgets/Button.dart';
import 'package:flutter_olx/CustomWidgets/TextField.dart';
import 'package:flutter_olx/CustomWidgets/style.dart';
import 'package:flutter_olx/Provider/User.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_olx/Screens/HomeScreen/HomePage.dart';
import 'package:flutter_olx/Screens/LoginPage.dart';

class ConfirmOtpPage extends StatefulWidget {
  String id, phone_no;

  var otpController = TextEditingController();

  ConfirmOtpPage(this.id, this.phone_no);

  @override
  _ConfirmOtpPageState createState() => _ConfirmOtpPageState();
}

class _ConfirmOtpPageState extends State<ConfirmOtpPage> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  var timer = "";

  var otpController = TextEditingController();
  var loading = false;
  var formkey = GlobalKey<FormState>();

  startTimer() async {
    for (int i = 240; i > 0; i--) {
      var min = i / 60;
      var sec = (min.floor() + 1) * 60 - min * 60;
      sec = 60 - sec;

      timer = "${min.floor()} : ${sec.floor()}";
      await Future.delayed(Duration(milliseconds: 1000));

      setState(() {});
    }

    showResendOtpDialog('Your OTP expired');
  }

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

  verifyOtp(otp) async {

    print('ccalled');
    loading = true;
    setState(() {

    });
    try {
      var url = 'http://radient.appnitro.co/api/User_registration/usersloginByOtp';
      var response = await http.post(url, body: {'enter_otp' : otp});
      var data = JsonDecoder().convert(response.body);
      print(data);
      if (data['status']) {
        User user = User();
        User.saveUser(response).then((value) => Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>HomePage())));
      } else {
       loading = false;
        setState(() {
        });
        showResendOtpDialog("incorrect OTP");
      }
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
      });
    }
  }

  resendOtp() async {
    print(widget.id);
    var url =
        'http://radient.appnitro.co/api/user_registration/resend-otp/${widget.id}';
    var response = await http.post(url);
    var data = JsonDecoder().convert(response.body);

    if (data['status']) {
      print(data);
      startTimer();
    } else {
      print(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'Confirm OTP',
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
                      'We Have Sent on your Mobile No.',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RadientTextFieldDense('Enter OTP', otpController, '',type: TextInputType.numberWithOptions()),
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
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RadientFlatButton('Resend OTP', Colors.yellow, () {
                          resendOtp();
                        }),
                        RadientGradientButton(context, 48.0, 150.0, () {
                          if (formkey.currentState.validate())
                            verifyOtp(otpController.text.trim());
                        }, 'Next', isLoading: loading)
                      ],
                    ),
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
