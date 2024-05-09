import 'package:flutter/material.dart';
import 'package:byme_flutter_app/utils/user/fetch_user_data.dart';

class HomePage extends StatefulWidget {
  final PageController pageController;

  const HomePage({Key? key, required this.pageController}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      future: fetchUserData(context, 'one', getDate()),
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
          final appointmentsToday = appointments.length;

          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width - 40,
                height: 230,
                decoration: BoxDecoration(
                    color: Color(0xFF787878).withOpacity(0.16),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xff672D6F),
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        snapshot.data?['user']['doctor']['fullname'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),
                      child: Row(children: [
                        Icon(Icons.medical_information_rounded),
                        Container(
                          width: 10,
                        ),
                        Text(
                          snapshot.data?['user']['doctor']['speciality'],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),
                      child: Row(children: [
                        Icon(Icons.business_rounded),
                        Container(
                          width: 10,
                        ),
                        Text(
                          snapshot.data?['user']['doctor']['hospital'],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),
                      child: Row(children: [
                        Container(
                          width: 5,
                        ),
                        Text('$appointmentsToday',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        Container(
                          width: 20,
                        ),
                        Text(
                          appointmentsToday > 1
                              ? 'Consultas para hoje'
                              : 'Consulta para hoje',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Color(0xff672D6F),
                            borderRadius: BorderRadius.circular(100)),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              widget.pageController.jumpToPage(3);
                            },
                            iconSize: 15,
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 20,
              ),
              Text(
                appointmentsToday > 1
                    ? 'Detalhes das consultas:'
                    : 'Detalhes da consulta:',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 260,
                child: ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      String name = appointments[index]['patient_data']['name'];
                      String processnumber =
                          appointments[index]['patient_data']['processnumber'];
                      String time = appointments[index]['time'];

                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Nome: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  '$name',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Nº Processo: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  '$processnumber',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Horário: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  '$time',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              )
            ],
          );
        }
      },
    );
  }
}
