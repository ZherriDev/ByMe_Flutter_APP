import 'package:byme_flutter_app/utils/user/fetch_user_data.dart';
import 'package:flutter/material.dart';

class DoctorProfile extends StatefulWidget {
  const DoctorProfile({super.key});

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
        future: fetchUserData(context, 'all', getDate()),
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      snapshot.data?['doctor']['fullname'],
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
                        Text(snapshot.data?['doctor']['hospital']),
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
                        children: [
                          Text(
                            'Consultas Agendadas',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                           'a',
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
                        children: [
                          Text(
                            'Pacientes',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'a',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            );
          }
        });
  }
}
