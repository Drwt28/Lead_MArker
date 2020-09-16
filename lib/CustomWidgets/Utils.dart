

String getDate(data)
{
  DateTime  date = DateTime.parse(data);

  return "${date.day}/${date.month}/${date.year}";
}


String makeTitleString(String data)
{
  try{
    String temp = data.toUpperCase();

    data = temp.substring(0,1)+temp.toLowerCase().substring(1,temp.length-1);
  }
  catch(e)
  {

  }
  return data;
}