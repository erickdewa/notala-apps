import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notala_apps/screens/DashboardScreen.dart';
import 'package:notala_apps/utils/OPWidgets.dart';
import 'package:notala_apps/utils/Constants.dart';

class TransactionCreateScreen extends StatefulWidget {
  final String type;

  TransactionCreateScreen({ required this.type });

  @override
  TransactionCreateScreenState createState() => TransactionCreateScreenState();
}

class TransactionCreateScreenState extends State<TransactionCreateScreen> {
  int? selectedCategory;
  TextEditingController categoryField = TextEditingController();
  TextEditingController amountField = TextEditingController();
  TextEditingController titleField = TextEditingController();
  TextEditingController dateField = TextEditingController();
  TextEditingController descriptionField = TextEditingController();

  int total = 0;
  int totalDebit = 0;
  int totalCredit = 0;
  List<dynamic> categories = [];
  List<dynamic> datas = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      categories = jsonDecode(prefs.getString(Constants.categoryFinance) ?? "[]");
      datas = jsonDecode(prefs.getString(Constants.dataFinance) ?? "[]");
      total = prefs.getInt(Constants.totalFinance) ?? 0;
      totalDebit = prefs.getInt(Constants.totalDebitFinance) ?? 0;
      totalCredit = prefs.getInt(Constants.totalCreditFinance) ?? 0;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void submitData() async {
    var prefs = await SharedPreferences.getInstance();

    if (amountField.text == '' || amountField.text == '0') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: Jumlah harus lebih dari 0!'),
        backgroundColor: Colors.deepOrange,
      ));
      return ;
    }

    if (titleField.text == '' || titleField.text.length == '0') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: Judul harus diisi!'),
        backgroundColor: Colors.deepOrange,
      ));
      return ;
    }

    datas.add({
      'id': datas.length + 1,
      'type': widget.type,
      'title': titleField.text,
      'amount': amountField.text,
      'category_id': selectedCategory,
      'description': descriptionField.text,
    });

    if(widget.type == 'debit') {
      total += int.parse(amountField.text);
      totalDebit += int.parse(amountField.text);
    } else {
      total -= int.parse(amountField.text);
      totalCredit += int.parse(amountField.text);
    }

    prefs.setInt(Constants.totalFinance, total);
    prefs.setInt(Constants.totalDebitFinance, totalDebit);
    prefs.setInt(Constants.totalCreditFinance, totalCredit);
    prefs.setString(Constants.dataFinance, jsonEncode(datas));

    DashboardScreen().launch(context);
  }

  void selectCategory() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: context.height() * 50 / 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text("Pilih Kategori", style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  height: context.height() * (50 - 8) / 100,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: categories.map<Widget>((dynamic option) {
                        return ListTile(
                          title: Text(option['name']),
                          onTap: () {
                            setState(() {
                              selectedCategory = option['id'];
                              categoryField.text = option['name'];
                              Navigator.pop(context);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => {
                        Navigator.pop(context)
                      },
                      icon: Icon(Icons.arrow_back_rounded, size: 30),
                    ),
                    SizedBox(width: 5),
                    Text("Buat Transaksi ${ widget.type == 'debit' ? 'Pemasukan' : 'Pengeluaran' }", style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    )),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  TextField(
                    controller: amountField,
                    obscureText: false,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: TextStyle(fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 14),
                    decoration: sSInputDecoration(
                      context: context,
                      name: 'Jumlah',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: titleField,
                    obscureText: false,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: TextStyle(fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 14),
                    decoration: sSInputDecoration(
                      context: context,
                      name: 'Judul',
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => {
                      selectCategory()
                    },
                    child: TextField(
                      enabled: false,
                      controller: categoryField,
                      obscureText: false,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: TextStyle(fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 14),
                      decoration: sSInputDecoration(
                        context: context,
                        name: 'Kategori',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: descriptionField,
                    obscureText: false,
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    style: TextStyle(fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 14),
                    decoration: sSInputDecoration(
                      context: context,
                      name: 'Deskripsi',
                    ),
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () => {
                      submitData()
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0), // Adjust the radius here
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Buat",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
