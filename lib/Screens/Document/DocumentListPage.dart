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

class _DocumentListPageState extends State<DocumentListPage> {





  List<Document> documentList;

  @override
  Widget build(BuildContext context)
  {
    documentList = Provider.of<UserDataProvider>(context).documents;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: red,
        onPressed: (){
          Navigator.push(context, CupertinoPageRoute(builder: (context)=>AddDocumentPage()));
        },
        child: Icon(Icons.add),

      ),
    appBar: AppBar(
      title: Text("Documents List"),
    ),

      body: (documentList==null)?Center(child: CircularProgressIndicator(),):(documentList.length>0)?
      ListView.builder(itemBuilder: (context,index)=>buildSingletile(documentList[index]),itemCount: documentList.length,):
      Center(child: InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddDocumentPage()));
          },
          child: Text("No Documents Yet")),),
    );
  }


  buildSingletile(Document document){
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      child: ListTile(
        onTap: (){
          Share.share("I am Sharing ${document.documentName} \n ${document.documentFile}  LeadMarker");
        },
        title: Text(document.documentName),
        trailing: Icon(Icons.share,color: Colors.red,size: 30,),
      ),
    );
  }



  @override
  void initState() {
    super.initState();
    Provider.of<UserDataProvider>(context,listen: false).getDocuments();
  }
}
