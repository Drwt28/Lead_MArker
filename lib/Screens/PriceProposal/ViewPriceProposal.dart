import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_olx/CustomWidgets/Button.dart';
import 'package:flutter_olx/CustomWidgets/Utils.dart';
import 'package:flutter_olx/Model/BusinessDetails.dart';
import 'package:flutter_olx/Model/PriceProposal.dart';
import 'package:flutter_olx/Model/UserData.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';


class ViewPriceProposal extends StatefulWidget {
  PriceProposal _priceProposal;

  Customer customer;

  ViewPriceProposal(this._priceProposal, this.customer);

  @override
  _ViewPriceProposalState createState() => _ViewPriceProposalState();
}

class _ViewPriceProposalState extends State<ViewPriceProposal> {
  BusinessDetails _businessDetails;

  var _key = GlobalKey();




  @override
  Widget build(BuildContext context) {
    _businessDetails = Provider.of<UserDataProvider>(context).businessDetails;
    return SafeArea(
      child: image != null
          ? Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                title: Text("Proposal"),
              ),
              body: PhotoView(
                imageProvider: MemoryImage(image),
              ),
            )
          : Material(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: RepaintBoundary(
                      key: _key,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              _businessDetails.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(color: Colors.black, fontSize: 12),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              _businessDetails.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                      color: Colors.black54, fontSize: 12),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              _businessDetails.address,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                      color: Colors.black54, fontSize: 12),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              _businessDetails.email,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(color: Colors.black, fontSize: 11),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              widget.customer.phoneNo[0] ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(color: Colors.black, fontSize: 11),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            divider(),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              color: Colors.black38,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Center(
                                  child: Text(
                                "Price Proposal ",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                        color: Colors.black, fontSize: 14),
                              )),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              _businessDetails.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                      color: Colors.black54, fontSize: 12),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            FittedBox(
                              child: DataTable(
                                  
                                  columns: [
                                buildColumnHead("#", context),
                                buildColumnHead("Description", context),
                                buildColumnHead("Quantity", context),
                                buildColumnHead("Amount", context),
                              ], rows: [
                                buildRow(context)
                              ]),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Total",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                            color: Colors.black, fontSize: 15),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Container(
                                    color: Colors.black38,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 2),
                                    child: Center(
                                        child: Text(
                                      widget._priceProposal.amount,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                              color: Colors.white,
                                              fontSize: 12),
                                    )),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Date ${getDate(DateTime.now().toString())}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                      color: Colors.black54, fontSize: 11),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              "Date ${getDate(DateTime(
                                DateTime.now().year,
                                DateTime.now().month + 1,
                              ).toString())}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(color: Colors.black, fontSize: 12),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Don;t hesitate to contact us if you have any questions \nwe are always at your service.\n ${_businessDetails.name}",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      .copyWith(
                                          color: Colors.black54, fontSize: 11),
                                ),
                                Text(
                                  "Created with \nLead Marker",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          color: Colors.black54, fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CupertinoButton(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                        child: Text("Save"),
                        onPressed: () async {
                          await getImageFile();
                          Provider.of<UserDataProvider>(context, listen: false)
                              .addPriceProposal(
                                  widget._priceProposal, file_image);
                        },
                      ),
                      CupertinoButton(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                        child: Text("Share"),
                        onPressed: () async {
                          await getImageFile();
                          // Provider.of<UserDataProvider>(context, listen: false)
                          //     .addPriceProposal(
                          //         widget._priceProposal, file_image);
                          _onShare(context);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }

  _onShare(BuildContext context) async {
    try {
      await Share.file(
          'esys image', 'esys.png', image, 'image/png', text: 'Sharing Price proposal');
    } catch (e) {
      print('error: $e');
    }
  }

  Uint8List image;

  File file_image;

  getImageFile() async {
    RenderRepaintBoundary boundary = _key.currentContext.findRenderObject();
    var data = await boundary.toImage(pixelRatio: 3);
    var byte = await data.toByteData(format: ImageByteFormat.png);
    var unit = byte.buffer.asUint8List();

    file_image = File.fromRawPath(unit);
    image = unit;
    setState(() {});
  }

  ExportToImage() async {
    RenderRepaintBoundary boundary = _key.currentContext.findRenderObject();
    var data = await boundary.toImage(pixelRatio: 3);
    var byte = await data.toByteData(format: ImageByteFormat.png);
    var unit = byte.buffer.asUint8List();

    file_image = File.fromRawPath(unit);
    image = unit;

    setState(() {});
  }

  DataRow buildRow(context) {
    return DataRow(
        
        cells: [
      DataCell(
          Text(
        '1',
        softWrap: true,
        textAlign: TextAlign.justify,
        maxLines: 10,
        overflow: TextOverflow.clip,
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(color: Colors.black, fontSize: 12),
      )),
      DataCell(Text(
        widget._priceProposal.description,
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(color: Colors.black, fontSize: 12),
      )),
      DataCell(Text(
        widget._priceProposal.quantity,
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(color: Colors.black, fontSize: 12),
      )),
      DataCell(Text(
        widget._priceProposal.amount,
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(color: Colors.black, fontSize: 12),
      )),
    ]);
  }

  DataColumn buildColumnHead(title, context) {
    return DataColumn(
      label: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(color: Colors.black, fontSize: 12),
      ),
    );
  }

  Widget divider() {
    return Container(
      height: 1,
      color: Colors.black54,
    );
  }
}
