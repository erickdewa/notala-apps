import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notala_apps/screens/ReportScreen.dart';
import 'package:notala_apps/screens/op_myCards.dart';
import 'package:notala_apps/utils/Colors.dart';
import 'op_atm_location_screen.dart';
import 'HomeScreen.dart';
import 'op_profile_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tab = [
      HomeScreen(),
      op_myCards(),
      ReportScreen(),
      OPAtmLocationScreen(),
      op_ProfileScreen(),
    ];

    return SafeArea(
      child: Scaffold(
        body: tab[_currentIndex],
        bottomNavigationBar: Stack(
          alignment: Alignment.center,
          children: [
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,
              selectedItemColor: opPrimaryColor,
              unselectedItemColor: opSecondaryColor.withOpacity(0.6),
              currentIndex: _currentIndex,
              elevation: 8.0,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home, size: 24), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.credit_card, size: 24), label: ''),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'images/orapay/opsplash.png',
                    width: 36,
                    height: 36,
                    color: Colors.white,
                  ),
                  label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.location_on, size: 24), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.person, size: 24), label: ''),
              ],
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            Image.asset('images/orapay/opsplash.png', width: 36, height: 36).onTap(() {
              setState(() {
                _currentIndex = 2;
              });
            }),
          ],
        ),
      ),
    );
  }
}
