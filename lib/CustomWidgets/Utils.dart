

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getDate(data)
{
  DateTime  date = DateTime.parse(data);

  final f = new DateFormat('dd-MMM-yyyy hh:mm a');

  return f.format(date);

  // return "${date.day}/${date.month}/${date.year} ${date.}";

}
Widget buildSingleItem(String title, image, onPressed,context) {
  return Card(
    child: ListTile(
      onTap: onPressed,
      leading: Image.asset(
        image,
        height: 34,
        width: 34,
      ),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .subtitle1
            .copyWith(fontWeight: FontWeight.w800, color: Colors.black),
      ),
    ),
  );
}


String makeTitleString(String data)
{
  try{
    String temp = data.toUpperCase();

    data = temp.substring(0,1)+temp.toLowerCase().substring(1,temp.length);
  }
  catch(e)
  {

  }
  return data;
}