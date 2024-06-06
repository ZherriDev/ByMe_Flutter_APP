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
      future: fetchUserData('one', getDate(), null, null, null),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          return const Center(
            child: Text('Erro ao carregar dados'),
          );
        } else {
          List<dynamic> appointments =
              snapshot.data?['appointments']['appointments'];
          final appointmentsToday = appointments.length;

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width - 40,
                  height: 230,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: const Color(0xff672D6F),
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          snapshot.data?['user']['doctor']['fullname'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(10),
                        child: Row(children: [
                          const Icon(Icons.medical_information_rounded),
                          Container(
                            width: 10,
                          ),
                          Text(
                            snapshot.data?['user']['doctor']['speciality'],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ]),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(10),
                        child: Row(children: [
                          const Icon(Icons.business_rounded),
                          Container(
                            width: 10,
                          ),
                          Text(
                            snapshot.data?['user']['doctor']['hospital'],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ]),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(10),
                        child: Row(children: [
                          Container(
                            width: 5,
                          ),
                          Text('$appointmentsToday',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Container(
                            width: 20,
                          ),
                          Text(
                            appointmentsToday > 1
                                ? 'Consultas para hoje'
                                : 'Consulta para hoje',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ]),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: const Color(0xff672D6F),
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                widget.pageController.jumpToPage(3);
                              },
                              iconSize: 15,
                              icon: const Icon(
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
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                if (appointmentsToday >= 1)
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    height: MediaQuery.of(context).size.height - 565,
                    child: ListView.builder(
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          String name =
                              appointments[index]['patient_data']['name'];
                          String processnumber = appointments[index]
                              ['patient_data']['processnumber'];
                          String time = appointments[index]['time'];

                          return GestureDetector(
                            onTap: () => widget.pageController.jumpToPage(1),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Nome: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                130),
                                        child: Text(
                                          name,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Nº Processo: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        processnumber,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Horário: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        time,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                else
                  SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      height: MediaQuery.of(context).size.height - 565,
                      child: const Center(
                        child:
                            Text('Você não tem consultas marcadas para hoje'),
                      ))
              ],
            ),
          );
        }
      },
    );
  }
}
