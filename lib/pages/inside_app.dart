import 'package:byme_flutter_app/pages/calendar_page.dart';
import 'package:byme_flutter_app/pages/homepage.dart';
import 'package:byme_flutter_app/pages/patients_page.dart';
import 'package:byme_flutter_app/pages/profile_page.dart';
import 'package:byme_flutter_app/pages/settings_page.dart';
import 'package:byme_flutter_app/utils/header_page_bar.dart';
import 'package:flutter/material.dart';
import 'package:byme_flutter_app/utils/fetch_user_data.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';

class InsideApp extends StatefulWidget {
  const InsideApp({super.key});

  @override
  State<InsideApp> createState() => _InsideAppState();
}

class _InsideAppState extends State<InsideApp> {
  int _currentIndex = 0;
  late PageController _pageController;
  late Future<Map<String, dynamic>?> userData;

  final List<String> appBarTexts = [
    'Página Inicial',
    'Calendário',
    'Pacientes',
    'Perfil',
    'Definições',
  ];

  @override
  void initState() {
    super.initState();
    userData = fetchUserData(context);
    _pageController = PageController(initialPage: _currentIndex);
  }

  setCurrentPage(value) {
    setState(() {
      _currentIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: userData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text('Erro ao carregar dados do utilizador'),
            ),
          );
        } else {
          var userData = snapshot.data!;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: HeaderPageBar(
              text: appBarTexts[_currentIndex],
              image: userData['doctor']['photo'],
            ),
            body: PageView(
              onPageChanged: setCurrentPage,
              controller: _pageController,
              children: [
                HomePage(),
                Calendar(),
                PatientsPage(),
                DoctorProfile(),
                SettingsPage(),
              ],
            ),
            bottomNavigationBar: Container(
              child: BottomNavigationBar(
                backgroundColor: Colors.black,
                currentIndex: _currentIndex,
                onTap: (value) {
                  _pageController.jumpToPage(
                      value); // Use jumpToPage para uma transição instantânea
                },
                unselectedItemColor: Colors.black54,
                items: const [
                  BottomNavigationBarItem(
                      backgroundColor: Color(0xff672D6F),
                      icon: Icon(Icons.home),
                      label: ''),
                  BottomNavigationBarItem(
                      backgroundColor: Color(0xff672D6F),
                      icon: Icon(FlutterIcons.calendar_ant),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.healing),
                      backgroundColor: Color(0xff672D6F),
                      label: ''),
                  BottomNavigationBarItem(
                      backgroundColor: Color(0xff672D6F),
                      icon: Icon(Icons.medical_services),
                      label: ''),
                  BottomNavigationBarItem(
                      backgroundColor: Color(0xff672D6F),
                      icon: Icon(Icons.settings),
                      label: ''),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
