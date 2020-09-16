import 'package:flutter/material.dart';
import 'package:flutter_olx/CustomWidgets/Label.dart';
import 'package:flutter_olx/CustomWidgets/Utils.dart';
import 'package:flutter_olx/DetailScreen.dart';

import 'package:flutter_olx/Model/UserData.dart';
import 'package:flutter_olx/Screens/HomeScreen/Lead/EditCustomerPage.dart';

import 'package:url_launcher/url_launcher.dart';


Widget buildSingleTile(context, var exp,
    {deletePressed, hidePressed, addPressed, Customer customer, Customer lead, isCustomer, expPressed,onLongPress,List<AddedLabel> labels,note}) {

  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Card(
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
                  onLongPress: onLongPress,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            detailScreen(customer: customer,
                              labels: labels,
                              lead: lead,
                              isCustomer: isCustomer,)
                    ));
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Text(getDate(customer.addedDate.toString()),style: TextStyle(fontSize: 13),)),
                      ),
                      ListTile(
                        leading: InkWell(
                          onTap: () {
                            try {
                              launch("tel: +91 ${isCustomer ? customer.phoneNo : lead
                                  .phoneNo}");
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Image.asset(
                            'images/Icons/CALL.png', height: 30, width: 30,),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                ("${isCustomer ? makeTitleString(customer.name) ?? '' : makeTitleString(lead.name) ??
                                    ''}  (${isCustomer ? makeTitleString(customer.company) ?? '' : makeTitleString(lead
                                    .company) ?? ''})"), style: Theme
                                  .of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(fontSize: 17, color: Colors.black),
                                textAlign: TextAlign.start,),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: SizedBox(
                                height: 22,
                                child:    ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: List.generate(
                                          labels.length, (index) =>
                                      RadientLabel(labels[index].color
                                        ,labels[index].labelName)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(note.length>0?note[0].note:"No Notes yet", textAlign: TextAlign.right, style: Theme
                                  .of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(color: Colors.black)),
                            )
                          ],
                        ),
                        subtitle:                       Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: exp,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(icon: Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.green,),
                                    onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>EditCustomerPage(customer)));
                                    },),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: deletePressed,),
                                ],
                              )
                              ,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                  onPressed: expPressed,
                                  icon: exp ? Icon(Icons.close, color: Colors.red,) : Icon(
                                    Icons.more_horiz, color: Colors.green,)),
                            )


                          ],
                        )
                        ,
                      ),
                    ],
                  ),
                ),
              ),


            ],
          ),
//          Positioned(
//            bottom: -4,
//            right: 3,
//            child: Align(
//              alignment: Alignment.bottomRight,
//              child: IconButton(
//                  onPressed: expPressed,
//                  icon: exp ? Icon(Icons.close, color: Colors.red,) : Icon(
//                    Icons.more_horiz, color: Colors.green,)),
//            ),
//          )

        ],
      ),
    ),
  );


//     return ExpansionPanel(
//        isExpanded: exp,
//        headerBuilder: (context,val)=>        ,  body:     );
}

