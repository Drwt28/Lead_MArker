import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_olx/Api/ApiClient.dart';
import 'package:flutter_olx/CustomWidgets/Button.dart';
import 'package:flutter_olx/Model/Document.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddDocumentPage extends StatefulWidget {
  @override
  _AddDocumentPageState createState() => _AddDocumentPageState();
}

class _AddDocumentPageState extends State<AddDocumentPage> {
  String docName, fileName;
  var loading = false;
  PlatformFile documentFile;

  pickDocument() async {
    var result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );
    documentFile = result.files.first;
    fileName = documentFile.name;
    setState(() {

    });
  }

  var formKey = GlobalKey<FormState>();

  var api = ApiClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (val){
                  docName = val;
                  setState(() {

                  });
                },
                validator: (val) => val.isEmpty ? "Enter Document Name" : null,
                decoration: InputDecoration(hintText: "Enter Document Name"),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
              child: ListTile(
                title: Text(fileName ?? "Add Document"),
                trailing: Icon(Icons.add),
                onTap: pickDocument,
              ),
            ),

            SizedBox(height: 20,),
            Center(
                child: RadientGradientButton(
                    context, 50.0, 200.0, () async{
                      setState(() {
                        loading = true;
                      });
                      await api.addDocument(Document(documentName: docName), documentFile);


                      Provider.of<UserDataProvider>(context,listen: false).getDocuments();
                      setState(() {
                        loading = false;
                      });

                      Navigator.pop(context);

                }, "Save Document",isLoading: loading))
          ],
        ),
      ),
    );
  }
}
