import 'package:flutter/material.dart';

Widget RadientGradientButton(context,height,width,onpressed,text,{isLoading}){
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
   borderRadius: BorderRadius.circular(20),
    gradient:LinearGradient(
      colors: [Colors.orange[600],Colors.orangeAccent[100]]
    )
  ),
    child: isLoading??false ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),),):InkWell(
      splashColor: Colors.deepOrange,
      onTap: onpressed,
      child: Center(child: Text(text,style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black),)),
    ),
  );
}

Widget RadientFlatButton(text,color,onPressed){
  return FlatButton(
    child: Text(text,style: TextStyle(fontWeight: FontWeight.w800),),
    onPressed: onPressed,
    textColor: color,
  );
}