import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_olx/CustomWidgets/Button.dart';
import 'package:flutter_olx/Model/Notes.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNotesPage extends StatefulWidget {

  String id;
  bool isCustomer;

  AddNotesPage({ this.id, this.isCustomer});

  @override
  _AddNotesPageState createState() => _AddNotesPageState();
}

class _AddNotesPageState extends State<AddNotesPage> {
  var loading = false;
  var addLeadNotesUrl = "http://radient.appnitro.co/api/leads_notes/add-notes/";
  var addCustomerNotesUrl =
      "http://radient.appnitro.co/api/customer_notes/add-notes/";
  var notesController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
      ),
      body: Form(
        key: formKey,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'enter note here',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                        width: 2,

                      ),
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  minLines: 1,
                  maxLines: 600,
                  validator: (val)=>val.isEmpty?"enter notes":null,
                  textAlign: TextAlign.center,

                  controller: notesController,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: RadientGradientButton(context, 50.0, 200.0, () {
        if (formKey.currentState.validate()) {


          addNotes(notesController.text.trim());
        }
      }, 'Add Notes',isLoading: loading),
    );
  }

  String _tokken;

  startLoading(){
    loading = true;
    setState(() {

    });
  }
  stopLoading(String message){
    loading = false;
    setState(() {

    });
  }

  addNotes(String note) async {
    Provider.of<UserDataProvider>(context,listen: false).addNote(Notes(note: note), widget.id);
    var pref = await SharedPreferences.getInstance();
    this._tokken = pref.getString('token');
    var url = 'http://radient.appnitro.co/api/customer_leads/insert-notes';
    var apikey = 'APIKEY@TEST';
    var response = await http.post(url, headers: {
      "x-api-key": apikey,
      'Auth': this._tokken
    }, body: {
      'cust_lead_id':widget.id,
      'note': note,
    });

    if(response.statusCode==200)
      {
      var data = JsonDecoder().convert(response.body);
      if(data['status'])
        {
          showDialog(context: context,child: AlertDialog(
            title: Text('Add Notes Succesfully'),
            actions: [
             RadientFlatButton('ok', Colors.red, (){
               Navigator.pop(context);
              // Navigator.pop(context);
             })
            ],
          ));
        }
      }
    else{
print(response.body);
    }
  }
}
