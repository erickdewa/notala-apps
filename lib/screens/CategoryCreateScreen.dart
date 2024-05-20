import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notala_apps/screens/CategoryListScreen.dart';
import 'package:notala_apps/utils/OPWidgets.dart';
import 'package:notala_apps/utils/Constants.dart';

class CategoryCreateScreen extends StatefulWidget {
  @override
  CategoryCreateScreenState createState() => CategoryCreateScreenState();
}

class CategoryCreateScreenState extends State<CategoryCreateScreen> {
  TextEditingController categoryField = TextEditingController();
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    var prefs = await SharedPreferences.getInstance();
    categories = jsonDecode(prefs.getString(Constants.categoryFinance) ?? "[]");
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void submitData() async {
    var prefs = await SharedPreferences.getInstance();

    if (categoryField.text.contains(' ')) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: Tidak boleh menggunakan spasi!'),
        backgroundColor: Colors.deepOrange,
      ));
      return ;
    }

    if (categoryField.text.length == 25) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: Nama terlalu panjang!'),
        backgroundColor: Colors.deepOrange,
      ));
      return ;
    }
    
    if(checkData()) {
      categories.add({
        'id': categories.length + 1,
        'code': categoryField.text.toUpperCase(),
        'name': categoryField.text,
      });

      prefs.setString(Constants.categoryFinance, jsonEncode(categories));
      CategoryListScreen().launch(context);
    }
  }

  bool checkData() {
    for (dynamic data in categories) {
      if(data['code'] == categoryField.text.toUpperCase()) {
        return false;
      }
    }

    return true;
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
                        CategoryListScreen().launch(context)
                      },
                      icon: Icon(Icons.arrow_back_rounded, size: 30),
                    ),
                    SizedBox(width: 5),
                    Text("Buat Katogori", style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    )),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Image.asset("images/notala/group.png",
                  width: context.width() * 60 / 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  Text("Tambahkan kategori baru untuk mengelompokan uang Anda", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  )),
                  SizedBox(height: 25),
                  TextField(
                    controller: categoryField,
                    obscureText: false,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: TextStyle(fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 14),
                    decoration: sSInputDecoration(
                      context: context,
                      name: 'Nama Kategori',
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
                            "Submit",
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
