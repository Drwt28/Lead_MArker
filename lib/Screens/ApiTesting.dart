import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

class TestingPage extends StatefulWidget {
  @override
  _TestingPageState createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {



  @override
  Widget build(BuildContext context) {
    return Container(

      child: Center(
        child: CupertinoButton(
          child: Text("Test"),
          onPressed: ()async{
           var resposone = await  http.post("http://accessor.easeltales.co/api/user-registration",body: {
             "first_name" : "trtrrd",
             "last_name" : "deepanshu",
             "phone_no" : "1234567790",
             "email_id" : "a@g.com",
             "user_type" : "UNREGISTERED",
              "gst_no" : "",
              "company_name" : "",
              "password" : "1234",
              "address" : "GopalPura",
              "state" : "Rajasthan",
              "pincode" : "302012",
              "city" : "Jaipur",
              "country" : "Jaipur",
              "aadhar_no" : "538548955727",
              "referral_code" : "",
              "confirm_password" : "1234",
              "composition" : "",
            });
           print(resposone.body);
          },
        ),
      ),
    );
  }
}
