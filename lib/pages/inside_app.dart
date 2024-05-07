import 'package:byme_flutter_app/pages/calendar_page.dart';
import 'package:byme_flutter_app/pages/homepage.dart';
import 'package:byme_flutter_app/utils/header_page_bar.dart';
import 'package:flutter/material.dart';
import 'package:byme_flutter_app/utils/verify_user.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';

class InsideApp extends StatefulWidget {
  const InsideApp({super.key});

  @override
  State<InsideApp> createState() => _InsideAppState();
}

class _InsideAppState extends State<InsideApp> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    verifyUser().then((loggedIn) {
      if (!loggedIn) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HeaderPageBar(
        text: 'Página Inicial',
        image: '',
      ),
      body: PageView(
        controller: _pageController,
        children: [
          HomePage(),
          Calendar(),
          // PatientListPage(),
          // ProfilePage(),
          // SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (value) {
          _pageController.animateToPage(value,
              duration: Duration(milliseconds: 400), curve: Curves.ease);
        },
        unselectedIconTheme: IconThemeData(color: Colors.black),
        items: const [
          BottomNavigationBarItem(
              backgroundColor: Color(0xff672D6F),
              icon: Icon(Icons.home),
              label: 'Home'),
          BottomNavigationBarItem(
              backgroundColor: Color(0xff672D6F),
              icon: Icon(FlutterIcons.calendar_ant),
              label: 'Calendar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.healing),
              backgroundColor: Color(0xff672D6F),
              label: 'Pacientes'),
          BottomNavigationBarItem(
              backgroundColor: Color(0xff672D6F),
              icon: Icon(Icons.medical_services),
              label: 'Perfil'),
          BottomNavigationBarItem(
              backgroundColor: Color(0xff672D6F),
              icon: Icon(Icons.settings),
              label: 'Definições'),
        ],
      ),
    );
  }
}
