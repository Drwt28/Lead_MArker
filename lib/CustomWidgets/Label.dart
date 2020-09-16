import 'package:flutter/material.dart';

Widget RadientLabel(color,text){
  color = Color(int.parse(color));
  return FittedBox(
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      padding: EdgeInsets.symmetric(horizontal: 4,vertical: 4),
      decoration: BoxDecoration(
          color: color,
        borderRadius: BorderRadius.circular(2)
      ),

      child: Center(child: Text(text,style: TextStyle(color: Colors.white,fontSize: 13),)),
    ),
  );
}