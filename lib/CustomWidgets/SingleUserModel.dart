import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleUserListCard extends StatefulWidget {
  @override
  _SingleUserListCardState createState() => _SingleUserListCardState();
}

class _SingleUserListCardState extends State<SingleUserListCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildSingleText("Rakesh Kumar"),
          buildSingleText("91-8956235689"),
          FittedBox(
            fit: BoxFit.fill,
              child: Row(
                  children: [
                    IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.remove_red_eye,color: Colors.green,),
                    ),
                    IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.edit,color: Colors.blue,),
                    ),
                    IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.remove_circle,color: Colors.red,),
                    )
                  ],
              ),
          )
        ],
      ),
    );
  }
  buildSingleText(String text){
    return Text(text,style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.black),);
  }
}
