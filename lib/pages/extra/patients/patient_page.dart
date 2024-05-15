import 'package:byme_flutter_app/utils/patients/fetch_patient_data.dart';
import 'package:flutter/material.dart';

class PatientPage extends StatefulWidget {
  final int patientId;
  final PageController pageController;
  final Function(int) modulePageID;

  const PatientPage(
      {Key? key,
      required this.patientId,
      required this.pageController,
      required this.modulePageID})
      : super(key: key);

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchPatientData(context, widget.patientId),
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
            List<dynamic> modules = snapshot.data?['modules']['modules'];

            return SingleChildScrollView(
              padding: EdgeInsets.only(left: 14, right: 14, bottom: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        iconSize: 35,
                        icon: Icon(Icons.edit_note),
                      ),
                      Container(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            snapshot.data?['patient']['patient']['name'],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            snapshot.data?['patient']['patient']
                                ['processnumber'],
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      Container(
                        width: 10,
                      ),
                      IconButton(
                        onPressed: () {},
                        iconSize: 35,
                        icon: Icon(Icons.delete_forever),
                      ),
                    ],
                  ),
                  Container(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                        color: Color(0xFF787878).withOpacity(0.16),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Color(0xff672D6F),
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              'Local de Morada',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Text(
                          '${snapshot.data?["patient"]["patient"]["address"]} - ${snapshot.data?["patient"]["patient"]["postalcode"]} - ${snapshot.data?["patient"]["patient"]["town"]}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                        color: Color(0xFF787878).withOpacity(0.16),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Color(0xff672D6F),
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              'E-mail',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Text(
                          snapshot.data?["patient"]["patient"]["email"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                        color: Color(0xFF787878).withOpacity(0.16),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Color(0xff672D6F),
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              'Nº Telefone',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Text(
                          '+351${snapshot.data?["patient"]["patient"]["telephone"]}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  Text(
                    'Módulos do Paciente:',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  if (modules.length >= 1)
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: MediaQuery.of(context).size.height - 600,
                      child: ListView.builder(
                          itemCount: modules.length,
                          itemBuilder: (context, index) {
                            int module_id = modules[index]['module_id'];
                            String episode = modules[index]['episode'];
                            String module = modules[index]['module'];
                            String status = modules[index]['status'];

                            return GestureDetector(
                              onTap: () {
                                widget.modulePageID(module_id);
                                widget.pageController.jumpToPage(8);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  height: 80,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Módulo $module',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Flexible(
                                          child: Text(
                                        episode,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      )),
                                      Text(
                                        status == "In Progress"
                                            ? 'Em progresso...'
                                            : status == "Finished"
                                                ? 'Acabado'
                                                : status == "Paused"
                                                    ? 'Pausado'
                                                    : status,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  else
                    Container(
                        width: MediaQuery.of(context).size.width - 40,
                        height: MediaQuery.of(context).size.height - 565,
                        child: Center(
                          child: Text(
                              'O paciente ainda não possui módulos adicionados'),
                        ))
                ],
              ),
            );
          }
        });
  }
}
