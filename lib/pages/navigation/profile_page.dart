import 'package:byme_flutter_app/pages/extra/profile/alert_dialog_logout.dart';
import 'package:byme_flutter_app/utils/user/fetch_user_data.dart';
import 'package:byme_flutter_app/pages/extra/profile/alert_dialog_logout.dart';
import 'package:flutter/material.dart';

class DoctorProfile extends StatefulWidget {
  final PageController pageController;

  const DoctorProfile({Key? key, required this.pageController})
      : super(key: key);

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  String getDate() {
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;
    int day = now.day;

    String todayDate = '$year-$month-$day';
    return todayDate;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
        future: fetchUserData('all', getDate(), null, null, null),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text('Erro ao carregar dados'),
            );
          } else {
            List<dynamic> appointments =
                snapshot.data?['appointments']['appointments'];
            final appointmentsAll = appointments.length;

            List<dynamic> patients = snapshot.data?['patients']['patients'];
            final patientsAll = patients.length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      snapshot.data?['user']['doctor']['fullname'],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.business_rounded),
                        Text(snapshot.data?['user']['doctor']['hospital']),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF672D6F),
                          borderRadius: BorderRadius.circular(12)),
                      width: 80,
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Consultas agendadas',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '$appointmentsAll',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 60),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF672D6F),
                          borderRadius: BorderRadius.circular(12)),
                      width: 80,
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Pacientes',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '$patientsAll',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  height: 250,
                  width: 340,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            widget.pageController.jumpToPage(5);
                          },
                          child: Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person),
                                Expanded(
                                    flex: 8,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Informações Pessoais',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ))),
                                Icon(Icons.chevron_right),
                              ],
                            ),
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 1, // Line thickness in pixels
                        color: Colors.grey[300], // Line color
                        indent: 20, // Indentation from left edge in pixels
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            widget.pageController.jumpToPage(7);
                          },
                          child: Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.lock),
                                Expanded(
                                    flex: 8,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Credenciais',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ))),
                                Icon(Icons.chevron_right)
                              ],
                            ),
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 1, // Line thickness in pixels
                        color: Colors.grey[300], // Line color
                        indent: 20, // Indentation from left edge in pixels
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            widget.pageController.jumpToPage(9);
                          },
                          child: Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.access_time),
                                Expanded(
                                    flex: 8,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Sessões da Conta',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ))),
                                Icon(Icons.chevron_right)
                              ],
                            ),
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 1, // Line thickness in pixels
                        color: Colors.grey[300], // Line color
                        indent: 20, // Indentation from left edge in pixels
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialogLogout();
                                });
                          },
                          child: Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.logout),
                                Expanded(
                                    flex: 8,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Terminar Sessão',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ))),
                                Icon(Icons.chevron_right)
                              ],
                            ),
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        });
  }
}
