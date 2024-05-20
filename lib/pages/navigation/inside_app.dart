import 'package:byme_flutter_app/pages/extra/profile/credentials_page.dart';
import 'package:byme_flutter_app/pages/extra/patients/module_page.dart';
import 'package:byme_flutter_app/pages/extra/profile/personal_info.dart';
import 'package:byme_flutter_app/pages/extra/patients/patient_page.dart';
import 'package:byme_flutter_app/pages/extra/profile/sessions_page.dart';
import 'package:byme_flutter_app/pages/navigation/calendar_page.dart';
import 'package:byme_flutter_app/pages/navigation/homepage.dart';
import 'package:byme_flutter_app/pages/navigation/patients_page.dart';
import 'package:byme_flutter_app/pages/navigation/profile_page.dart';
import 'package:byme_flutter_app/pages/navigation/settings_page.dart';
import 'package:byme_flutter_app/utils/user/verify_user.dart';
import 'package:byme_flutter_app/utils/widgets/header_page_bar.dart';
import 'package:flutter/material.dart';
import 'package:byme_flutter_app/utils/user/fetch_user_data.dart';

import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';

class InsideApp extends StatefulWidget {
  const InsideApp({super.key});

  @override
  State<InsideApp> createState() => _InsideAppState();
}

class _InsideAppState extends State<InsideApp> {
  int _currentIndex = 0;
  late PageController _pageController;
  late Future<Map<String, dynamic>?> userData;
  var userPhoto;

  final List<String> appBarTexts = [
    'Página Inicial',
    'Calendário',
    'Pacientes',
    'Perfil',
    'Definições',
  ];

  String getDate() {
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;
    int day = now.day;

    String todayDate = '$year-$month-$day';
    return todayDate;
  }

  @override
  void initState() {
    super.initState();
    userData = fetchUserData('one', getDate(), null, null, null);
    _pageController = PageController(initialPage: _currentIndex);
    userPhoto = "";
  }

  setCurrentPage(value) {
    setState(() {
      if (value < 5) {
        _currentIndex = value;
      }
    });
  }

  int patientId = 0;
  int moduleId = 0;

  void patientPageID(int patient_id) {
    setState(() => patientId = patient_id);
  }

  void modulePageID(int module_id) {
    setState(() => moduleId = module_id);
  }

  void reloadPhoto(String newPhoto) {
    setState(() => userPhoto = newPhoto);
  }

  @override
  Widget build(BuildContext context) {
    verifyUser().then((loggedIn) {
      if (!loggedIn) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    });

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
              image: userPhoto != ""
                  ? userPhoto
                  : userData['user']['doctor']['photo'],
            ),
            body: PageView(
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: setCurrentPage,
              controller: _pageController,
              children: [
                HomePage(
                  pageController: _pageController,
                ),
                CalendarPage(
                  pageController: _pageController,
                ),
                PatientsPage(
                    pageController: _pageController,
                    patientPageID: patientPageID),
                DoctorProfile(
                  pageController: _pageController,
                ),
                SettingsPage(
                  pageController: _pageController,
                ),
                PersonalInfo(
                    pageController: _pageController, reloadPhoto: reloadPhoto),
                PatientPage(
                  patientId: patientId,
                  pageController: _pageController,
                  modulePageID: modulePageID,
                ),
                CredentialsPage(
                  pageController: _pageController,
                ),
                ModulePage(moduleId: moduleId, pageController: _pageController),
                SessionsPage(pageController: _pageController),
              ],
            ),
            bottomNavigationBar: CurvedNavigationBar(
                animationDuration: Duration(milliseconds: 250),
                index: _currentIndex,
                color: Color(0xff672D6F),
                backgroundColor: Colors.white,
                onTap: (index) {
                  _pageController.jumpToPage(index);
                },
                items: [
                  CurvedNavigationBarItem(
                    child: Icon(Icons.home_outlined, color: Colors.white),
                  ),
                  CurvedNavigationBarItem(
                    child: Icon(Icons.calendar_month, color: Colors.white),
                  ),
                  CurvedNavigationBarItem(
                    child: Icon(Icons.personal_injury_outlined,
                        color: Colors.white),
                  ),
                  CurvedNavigationBarItem(
                    child: Icon(Icons.perm_identity, color: Colors.white),
                  ),
                  CurvedNavigationBarItem(
                    child: Icon(Icons.settings_outlined, color: Colors.white),
                  ),
                ]),
          );
        }
      },
    );
  }
}
