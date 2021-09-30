// ignore_for_file: prefer_const_constructors

import 'package:banking_testapp/services/balance.dart';
import 'package:banking_testapp/services/deposit.dart';
import 'package:banking_testapp/services/withdraw.dart';
import 'package:flutter/material.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  String? amount;
  int? balance;
  final _formKeyDeposit = GlobalKey<FormState>();
  final _formKeyWithdraw = GlobalKey<FormState>();

  Future<void> userBalance() async {
    Balance instance = Balance();
    await instance.getBalance();
    setState(() {
      balance = instance.data!["amount"];
    });
  }

  Future<void> makeDeposit(amount) async {
    Deposit instance = Deposit(amount: amount);
    await instance.newDeposit();
    if (instance.statusCode != 200) {
      final snackBar = SnackBar(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        backgroundColor: Colors.red,
        content: Text("${instance.data!["message"]}",
            style: TextStyle(fontSize: 20, letterSpacing: 2)),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (instance.statusCode == 200) {
      userBalance();
      final snackBar = SnackBar(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        backgroundColor: Colors.green[200],
        content: Text("${instance.data!["message"]}",
            style: TextStyle(fontSize: 20, letterSpacing: 2)),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> makeWithDrawal(amount) async {
    Withdraw instance = Withdraw(amount: amount);
    await instance.newWithDraw();
    if (instance.statusCode != 200) {
      final snackBar = SnackBar(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        backgroundColor: Colors.red,
        content: Text("${instance.data!["message"]}",
            style: TextStyle(fontSize: 20, letterSpacing: 2)),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (instance.statusCode == 200) {
      userBalance();
      final snackBar = SnackBar(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        backgroundColor: Colors.green[200],
        content: Text("${instance.data!["message"]}",
            style: TextStyle(fontSize: 20, letterSpacing: 2)),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget buildBalance() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            splashColor: Colors.cyan,
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            onTap: () {},
            child: Card(
              color: Colors.grey[200],
              elevation: 5,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: SizedBox(
                height: 100,
                child: LayoutBuilder(builder: (context, constraint) {
                  return (Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.money,
                          // size: constraint.maxWidth,
                          color: Colors.black45,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Balance",
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: 20,
                                letterSpacing: 2)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("$balance",
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: 20,
                                letterSpacing: 2)),
                      )
                    ],
                  ));
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSubmitDeposit() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
      child: ElevatedButton.icon(
          onPressed: () {
            if (_formKeyDeposit.currentState!.validate()) {
              _formKeyDeposit.currentState!.save();
              makeDeposit(amount);
            }
          },
          icon: Icon(Icons.send, color: Colors.white),
          label: Text("Submit", style: TextStyle(color: Colors.white))),
    );
  }

  Widget buildSubmitWithdraw() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
      child: ElevatedButton.icon(
          onPressed: () {
            if (_formKeyWithdraw.currentState!.validate()) {
              _formKeyWithdraw.currentState!.save();
              makeWithDrawal(amount);
            }
          },
          icon: Icon(Icons.send, color: Colors.white),
          label: Text("Submit", style: TextStyle(color: Colors.white))),
    );
  }

  Widget buildDepositForm() {
    return Card(
      color: Colors.grey[200],
      elevation: 5,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.money),
                  labelText: "Enter amount to deposit",
                  labelStyle: TextStyle(
                      fontSize: 16, color: Colors.black, letterSpacing: 2),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please input amount";
                  }
                },
                onChanged: (value) {
                  amount = value;
                }),
          ),
          buildSubmitDeposit()
        ],
      ),
    );
  }

  Widget buildWithDrawForm() {
    return Card(
      color: Colors.grey[200],
      elevation: 5,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.money),
                  labelText: "Enter amount to withdraw",
                  labelStyle: TextStyle(fontSize: 16, color: Colors.black),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please input amount";
                  }
                },
                onChanged: (value) {
                  amount = value;
                }),
          ),
          buildSubmitWithdraw()
        ],
      ),
    );
  }

  Widget buildPage() {
    return Column(
      children: [
        buildBalance(),
        Form(key: _formKeyDeposit, child: Expanded(child: buildDepositForm())),
        Form(key: _formKeyWithdraw, child: Expanded(child: buildWithDrawForm()))
      ],
    );
  }

  @override
  // ignore: must_call_super
  void initState() {
    userBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Banking Test App")),
      body: buildPage(),
    );
  }
}
