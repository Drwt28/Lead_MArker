import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_olx/CustomWidgets/style.dart';
import 'package:flutter_olx/Model/Document.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';
import 'package:flutter_olx/Screens/Document/AddDocumentPage.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class DocumentListPage extends StatefulWidget {
  @override
  _DocumentListPageState createState() => _DocumentListPageState();
}

class _DocumentListPageState extends State<DocumentListPage> with TickerProviderStateMixin {
  bool multiSelect = false;

  List<Document> documentList;

  List<bool> selected = List.generate(100, (index) => false);




  @override
  Widget build(BuildContext context) {
    documentList = Provider.of<UserDataProvider>(context).documents;
    return WillPopScope(
      onWillPop: () async {
        if (multiSelect) {
          multiSelect = false;
          setState(() {});
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        floatingActionButton: multiSelect
            ? FloatingActionButton(
                backgroundColor: red,
                onPressed: () {
                  String doc_ext = "";
                  String doc_name = "";

                  for (var doc in documentList) {
                    if (doc.selected) {
                      doc_ext = doc_ext + "${doc.document_ext},";
                      doc_name = doc_name + "${doc.documentName},";
                    }
                  }

                  String content =
                      "http://radient.appnitro.co/shared-documents?doc_ext=${doc_ext}&doc_name=${doc_name}";

                  Share.share(content);

                  print(content);
                },
                child: Icon(Icons.share),
              )
            : FloatingActionButton(
                backgroundColor: red,
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => AddDocumentPage()));
                },
                child: Icon(Icons.add),
              ),
        appBar: AppBar(
          title: Text("Documents List"),
        ),
        body: multiSelect
            ? buildMultiSelect(documentList)
            : (documentList == null)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : (documentList.length > 0)
                    ? Transform.translate(
          offset: Offset(0,fadeAnimation.value),
          child: ListView.builder(
                            itemBuilder: (context, index) =>
                                buildSingletile(documentList[index]),
                            itemCount: documentList.length,
                          ),
                    )
                    : Center(
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddDocumentPage()));
                            },
                            child: Text("No Documents Yet")),
                      ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
  }

  buildSingletile(Document document) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onLongPress: () {
          multiSelect = true;
          setState(() {});
        },
        onTap: () {
          Share.share(
              "I am Sharing ${document.documentName} \n ${document.documentFile}  LeadMarker");
        },
        title: Text(document.documentName),
        trailing: Icon(
          Icons.share,
          color: Colors.red,
          size: 30,
        ),
      ),
    );
  }

  Widget buildMultiSelect(list) {
    return (documentList.length > 0)
        ? ListView.builder(
            itemBuilder: (context, index) => Card(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: CheckboxListTile(
                value: documentList[index].selected,
                onChanged: (val) {
                  // Share.share("I am Sharing ${document.documentName} \n ${document.documentFile}  LeadMarker");
                  //

                  documentList[index].selected = val;
                  setState(() {});
                },
                title: Text(list[index].documentName),
              ),
            ),
            itemCount: documentList.length,
          )
        : Center(
            child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddDocumentPage()));
                },
                child: Text("No Documents Yet")),
          );
  }


  Animation<double> animation,fadeAnimation;

  AnimationController animationController,fadeController;



  @override
  void initState() {
    super.initState();

    fadeController = AnimationController(

        vsync: this,duration: Duration(milliseconds: 3000))..addListener(() {
      setState(() {

      });
    });





    fadeAnimation = Tween<double>(begin:-1000,end:0.0).animate(CurvedAnimation(parent: fadeController,curve: Curves.decelerate));



    fadeController.forward();


    Provider.of<UserDataProvider>(context, listen: false).getDocuments();
  }


}

