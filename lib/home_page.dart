import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:tinda/screens/cashier_screen.dart';
import 'package:tinda/screens/inventory_screen.dart';
import 'package:tinda/screens/reporting_screen.dart';
import 'package:tinda/widgets/build_fontAwesome.dart';

class HomePage extends StatefulWidget {
  //Key for BottomNavigation
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey _bottomNavigationKey = GlobalKey();
  bool newUser;
  PageController _pageController = PageController();

  List<Widget> _screens = [
    InventoryScreen(),
    CashierScreen(),
    ReportingScreen()
  ];

  int _selectedIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.animateToPage(selectedIndex,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  @override
  void initState() {
    super.initState();

    newUserChecker().then((_) {
      if (newUser == true) {
        saveUserInfoToFireStore();
      }
    });
  }

  isNewUser() async {
    final user = FirebaseAuth.instance.currentUser;
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: user.email)
        .get();
    final List<DocumentSnapshot> docs = result.docs;
    return docs.length == 0 ? true : false;
  }

  Future<void> newUserChecker() async {
    newUser = await isNewUser();
  }

  Future saveUserInfoToFireStore() async {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'name': user.displayName,
      'class': 2,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _selectedIndex,
        height: 50.0,
        color: Colors.teal,
        backgroundColor: Colors.grey.shade200,
        buttonBackgroundColor: Colors.yellow.shade900,
        animationCurve: Curves.easeIn,
        animationDuration: Duration(milliseconds: 200),
        onTap: _onItemTapped,
        //create buildFaIcon widget with preset size and color for cleaner code
        items: <Widget>[
          BuildFaIcon(FontAwesomeIcons.cubes),
          BuildFaIcon(FontAwesomeIcons.cashRegister),
          BuildFaIcon(FontAwesomeIcons.briefcase),
        ],
      ),
      // this is the main widget to change pages
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
      ),
    );
  }
}
