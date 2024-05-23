import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notala_apps/screens/DashboardScreen.dart';
import 'package:notala_apps/utils/OPWidgets.dart';
import 'package:notala_apps/utils/Constants.dart';

class GetToKnowScreen extends StatefulWidget {
  @override
  GetToKnowScreenState createState() => GetToKnowScreenState();
}

class GetToKnowScreenState extends State<GetToKnowScreen> {
  TextEditingController fullNameField = TextEditingController();
  TextEditingController genderField = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void submitData() async {
    var prefs = await SharedPreferences.getInstance();

    if (fullNameField.text.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Masukan Nama Anda!'),
        backgroundColor: Colors.deepOrange,
      ));
      return ;
    }

    if (fullNameField.text.length == 25) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Nama Anda terlalu panjang!'),
        backgroundColor: Colors.deepOrange,
      ));
      return ;
    }

    if (genderField.text.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Anda belum memilih jenis kelamin!'),
        backgroundColor: Colors.deepOrange,
      ));
      return ;
    }

    String callName = fullNameField.text;
    if(fullNameField.text.contains(" ")){
      callName = fullNameField.text.substring(0, fullNameField.text.indexOf(' '));
    }

    prefs.setString(Constants.genderFinance, genderField.text);
    prefs.setString(Constants.callnameFinance, callName);
    prefs.setString(Constants.fullnameFinance, fullNameField.text);

    List<dynamic> categories = [];
    categories.add({ 'id': 1, 'code': 'pendidikan', 'name': 'Pendidikan' });
    categories.add({ 'id': 2, 'code': 'modal-usaha', 'name': 'Modal Usaha' });
    categories.add({ 'id': 3, 'code': 'hutang', 'name': 'Hutang' });
    categories.add({ 'id': 4, 'code': 'piutang', 'name': 'Piutang' });
    categories.add({ 'id': 5, 'code': 'kesehatan', 'name': 'Kesehatan' });
    categories.add({ 'id': 6, 'code': 'fashion', 'name': 'Fashion' });
    prefs.setString(Constants.categoryFinance, jsonEncode(categories));

    DashboardScreen().launch(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: context.height() * 5 / 100),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Image.asset("images/notala/kenalan.png",
                      width: context.width() * 80 / 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: context.height() * 49 / 100,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Selamat Datang!", style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      )),
                      SizedBox(height: 10),
                      Text("Mari berkenalan, masukan informasi tentang Anda! ", style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      )),
                      SizedBox(height: 25),
                      TextField(
                        controller: fullNameField,
                        obscureText: false,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        style: TextStyle(fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 14),
                        decoration: sSInputDecoration(
                          context: context,
                          name: 'Nama Lengkap',
                        ),
                      ),SizedBox(height: 25),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Pilih Jenis Kelamin', style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                )),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      title: Text('Laki-laki'),
                                      onTap: () {
                                        setState(() {
                                          genderField.text = 'Laki-Laki';
                                        });

                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text('Perempuan'),
                                      onTap: () {
                                        setState(() {
                                          genderField.text = 'Perempuan';
                                        });

                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: TextField(
                          enabled: false,
                          controller: genderField,
                          obscureText: false,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          style: TextStyle(fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 14),
                          decoration: sSInputDecoration(
                            context: context,
                            name: 'Jenis Kelamin'
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () => {
                          submitData()
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0XFFFD7E14),
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
                                "Mulai Sekarang",
                                style: TextStyle(
                                  color: Colors.black,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
