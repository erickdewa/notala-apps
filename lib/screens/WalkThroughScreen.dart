import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notala_apps/screens/GetToKnowScreen.dart';
import 'package:notala_apps/utils/OPWidgets.dart';

class WalkThroughScreen extends StatefulWidget {
  static String tag = '/WalkThroughScreen';

  @override
  _WalkThroughScreenState createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  PageController pageController = PageController(initialPage: 0);
  int pageChanged = 0;
  DateTime? backbuttonpressedTime;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> buildDotIndicator() {
      List<Widget> list = [];
      for (int i = 0; i <= 2; i++) {
        list.add(i == pageChanged ? oPDotIndicator(isActive: true) : oPDotIndicator(isActive: false));
      }

      return list;
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child: PageView(
                  onPageChanged: (index) {
                    setState(() {
                      pageChanged = index;
                    });
                  },
                  controller: pageController,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 50),
                            height: context.height() * 0.5,
                            padding: EdgeInsets.only(top: 16),
                            alignment: Alignment.topRight,
                            child: Image(
                              image: AssetImage("images/notala/catat.png"),
                            ),
                          ),
                          height: size.height * 0.5,
                        ),
                        Positioned(
                          top: size.height / 1.8,
                          left: 24,
                          right: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Pencatatan Transaksi", textAlign: TextAlign.center, style: boldTextStyle(size: 27)),
                              SizedBox(height: 16.0),
                              Text("Catat semua transaksi keuangan Anda secara teratur", textAlign: TextAlign.center, style: secondaryTextStyle(size: 18))
                            ],
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(30),
                          height: context.height() * 0.5,
                          child: Image(
                            image: AssetImage("images/notala/analisis.png"),
                          ),
                        ),
                        Positioned(
                          top: size.height / 1.8,
                          left: 24,
                          right: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Analisis Keuangan", textAlign: TextAlign.center, style: boldTextStyle(size: 27)),
                              SizedBox(height: 16.0),
                              Text("Telusuri dan analisis pola pengeluaran Anda dengan grafik intuitif", maxLines: 3, textAlign: TextAlign.center, style: secondaryTextStyle(size: 18))
                            ],
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(30),
                          height: context.height() * 0.5,
                          child: Image(
                            image: AssetImage("images/notala/mudah.png"),
                          ),
                        ),
                        Positioned(
                          top: size.height / 1.8,
                          left: 24,
                          right: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Mudah Digunakan", textAlign: TextAlign.center, style: boldTextStyle(size: 27)),
                              SizedBox(height: 16.0),
                              Text("Mulai perjalanan keuangan Anda dengan Aplikasi kami!", textAlign: TextAlign.center, style: secondaryTextStyle(size: 18))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  pageChanged == 0
                      ? Expanded(
                          child: SizedBox(),
                          flex: 1,
                        )
                      : Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                            ),
                            child: SliderButton(
                              color: Colors.black,
                              title: 'Back',
                              onPressed: () {
                                pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInCirc);
                              },
                            ),
                          ),
                        ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: buildDotIndicator(),
                    ),
                  ),
                  pageChanged != 2
                      ? Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: 20,
                            ),
                            child: SliderButton(
                              color: Color(0XFFFD7E14),
                              title: 'Next',
                              onPressed: () {
                                pageController.nextPage(duration: Duration(milliseconds: 250), curve: Curves.easeInCirc);
                              },
                            ),
                          ),
                        )
                      : Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: 20,
                            ),
                            child: SliderButton(
                              color: Color(0XFFFD7E14),
                              title: 'Mulai',
                              onPressed: () {
                                GetToKnowScreen().launch(context);
                              },
                            ),
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
