import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_olx/Api/ApiClient.dart';
import 'package:flutter_olx/CustomWidgets/Button.dart';
import 'package:flutter_olx/CustomWidgets/TextField.dart';
import 'package:flutter_olx/CustomWidgets/style.dart';
import 'package:flutter_olx/Model/PriceProposal.dart';
import 'package:flutter_olx/Model/UserData.dart';
import 'package:flutter_olx/Provider/UserDataProvider.dart';
import 'package:flutter_olx/Screens/PriceProposal/ViewPriceProposal.dart';
import 'package:provider/provider.dart';

class CreatePricePosal extends StatefulWidget {
  @override
  _CreatePricePosalState createState() => _CreatePricePosalState();
}

class _CreatePricePosalState extends State<CreatePricePosal> {
  List<bool> selected = List.generate(15, (index) => false);
  ApiClient apiClient = ApiClient();

  var customerNameController = TextEditingController();
  var descriptionController = TextEditingController();
  var quantityController = TextEditingController();
  var amountController = TextEditingController();


  String customerName,description,quantity,amount;

  Widget buildSelectUserWidget(List customers) {
    List<bool> selected = List.generate(customers.length, (index) => false);

    showDialog(
        context: context,
        child: StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(
              "Choose Customer/Lead",
              style: Theme.of(context).textTheme.headline6,
            ),
            actions: [
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
            content: Container(
              height: 300,
              width: 250,
              child: ListView.builder(
                shrinkWrap: true,
                itemExtent: 60,
                itemBuilder: (context, index) => buildSingleSelectTile(
                    customers[index], index, selected, setState),
                itemCount: customers.length,
              ),
            ),
          ),
        ));
  }

  var selectedIndex = -1;

  Widget buildSingleSelectTile(Customer customer, index, selected, setstate) {
    return RadioListTile(
      groupValue: selectedIndex,
      value: index,
      onChanged: (val) {
        setstate(() {
          selectedIndex = index;
        });
        setState(() {});

        customerNameController.text = customer.name;
      },
      title: Text(customer.name + "\t${customer.company}"),
      subtitle: Text(customer.userType),
    );
  }

  var scaffold = GlobalKey<ScaffoldState>();

  var remDate;
  var note = '';
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    List customers = Provider.of<UserDataProvider>(context).totalCustomers;
    return Scaffold(
      key: scaffold,
      appBar: AppBar(
        title: Text('Add Price Proposal'),
      ),
      body: Form(
        key: formkey,
        child: ListView(
          children: [
            buildDivider(),
            buildSingleTile(
                Icons.account_circle, 'Select Customer/Lead Optional', () {
              buildSelectUserWidget(customers);
            },
                selectedIndex != -1
                    ? customers[selectedIndex].name
                    : 'select Customer'),
            buildDivider(),
            buildTextField("To", "Enter Customer name", (val) {

              customerName = val;
            }, customerNameController, keyboardType: TextInputType.name),
            buildTextField("Description", "enter description", (val) {

              description =val;
            }, descriptionController),
            buildTextField("Quantity", "enter quantity", (val) {

              quantity =val;
            }, quantityController, keyboardType: TextInputType.number),
            buildTextField("Amount", "enter Amount", (val) {
              amount = val;

            }, amountController, keyboardType: TextInputType.number),
            SizedBox(
              height: 20,
            ),
            Center(


                child: RadientGradientButton(context, 50.0, 200.0, () {
                  Customer customer;
                  String id ="";
                  try{
                    customer = customers[selectedIndex];
                    id = customer.id;
                  }catch(e)
                  {

                  }

                  customer = Customer(
                    name: customerNameController.text,
                    phoneNo: [""],
                    address: "",
                    email: [""],
                    company: "",

                  );
                  PriceProposal pri = PriceProposal();
                  pri.amount =amount;
                  pri.quantity = quantity;
                  pri.description = description;
                  pri.custLeadName = customerNameController.text;
                  pri.custLeadId = id;

              Navigator.push(context, CupertinoPageRoute(builder: (context)=>ViewPriceProposal(pri,customer)));
            }, "View Proposal"))
                      ],
        ),
      ),
    );
  }

  buildDivider() {
    return Divider(
      color: Colors.black12,
      thickness: 1,
      height: 1,
    );
  }

  buildTextField(titl, hint, onChanged, controller, {keyboardType}) {
    return Row(
      children: [
        SizedBox(
          width: 24,
        ),
        Text(
          titl,
          style: Theme.of(context).textTheme.headline6.copyWith(
                fontSize: 16,
              ),
        ),
        Expanded(
            child: RadientTextField(hint, controller, false,
                onChanged: onChanged, inputType: keyboardType)),
      ],
    );
  }

  buildSingleTile(icon, heading, onPressed, buttonText) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: red,
              size: 30,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              heading,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.black54),
            ),
          ],
        ),
      ),
      subtitle: RadientFlatButton(buttonText, Colors.red, onPressed),
    );
  }
}
