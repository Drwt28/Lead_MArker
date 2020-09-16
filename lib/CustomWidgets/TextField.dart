import 'package:flutter/material.dart';

Widget RadientTextField(hint,controller,password,{inputType,onChanged,requestFocus}){
  return Padding(
    padding: const EdgeInsets.only(top: 8,bottom: 8,right: 25,left: 25),
    child: TextFormField(
      autofocus: requestFocus??false,
      onChanged: onChanged,
      validator: (value) => value.isEmpty?'Enter $hint':null,
      controller: controller,
      keyboardType: inputType??TextInputType.text,
      decoration: InputDecoration(
        labelText: hint,
        hintStyle: TextStyle(color: Colors.black54,)
      ),
    ),
  );
}
Widget RadientTextFieldImage(image ,hint,controller,password,{bool isValidate}){
  if(isValidate==null)
    isValidate = false;
  return Padding(
    padding: const EdgeInsets.only(top: 8,bottom: 8,right: 25,left: 25),
    child: TextFormField(
      validator: isValidate?(value) => value.isEmpty?'Enter $hint':null:null,
      controller: controller,
      decoration: InputDecoration(
      icon: Image.asset(image,width: 25,height: 25,),
          labelText: hint,
          hintStyle: TextStyle(color: Colors.black54,)
      ),
    ),
  );
}
Widget RadientTextFieldWhite(hint,controller,password){
  return Padding(
    padding: const EdgeInsets.only(top: 8,bottom: 8,right: 25,left: 25),
    child: TextFormField(

      controller: controller,
      style: TextStyle(color: Colors.white,fontSize: 16),
      decoration: InputDecoration(
        labelText: hint,
        focusColor: Colors.white,
        hoverColor: Colors.white,
        labelStyle: TextStyle(color: Colors.yellow,)
      ),
    ),
  );
}Widget RadientTextFieldDense(hint,controller,password,{type}){
  return new TextFormField(
    controller: controller,
    keyboardType: type??TextInputType.emailAddress,
    textAlign: TextAlign.center,
    decoration: new InputDecoration(
        border: new OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(30.0),
          ),
        ),
        filled: true,
        focusColor: Colors.white,
        hintStyle: new TextStyle(color: Colors.grey[800]),
        hintText: hint,
        fillColor: Colors.white),
  );
}