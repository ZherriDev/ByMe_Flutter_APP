import 'package:byme_flutter_app/pages/extra/profile/credentials_page.dart';
import 'package:byme_flutter_app/pages/extra/profile/personal_info.dart';
import 'package:byme_flutter_app/pages/extra/patients/patient_page.dart';
import 'package:byme_flutter_app/pages/navigation/calendar_page.dart';
import 'package:byme_flutter_app/pages/navigation/homepage.dart';
import 'package:byme_flutter_app/pages/navigation/patients_page.dart';
import 'package:byme_flutter_app/pages/navigation/profile_page.dart';
import 'package:byme_flutter_app/pages/navigation/settings_page.dart';
import 'package:byme_flutter_app/utils/user/verify_user.dart';
import 'package:byme_flutter_app/utils/widgets/header_page_bar.dart';
import 'package:flutter/material.dart';
import 'package:byme_flutter_app/utils/user/fetch_user_data.dart';
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
    userData = fetchUserData(context, 'one', getDate(), null, null, null);
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

  void patientPageID(int patient_id) {
    setState(() => patientId = patient_id);
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
                ),
                CredentialsPage(pageController: _pageController,),

              ],
            ),
            bottomNavigationBar: Container(
              child: BottomNavigationBar(
                backgroundColor: Colors.black,
                currentIndex: _currentIndex,
                onTap: (value) {
                  _pageController.jumpToPage(value);
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
