import 'package:byme_flutter_app/utils/patients/fetch_patient_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PatientPage extends StatefulWidget {
  final int patientId;
  final PageController pageController;

  const PatientPage(
      {Key? key, required this.patientId, required this.pageController})
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 8, right: 8, top: 6, bottom: 6),
                          height: MediaQuery.of(context).size.height / 2 - 250,
                          decoration: BoxDecoration(
                              color: Color(0xFF787878).withOpacity(0.16),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(6),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Color(0xff672D6F),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Text(
                                  'Opções de Contacto:',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                              Container(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.call),
                                  Container(
                                    width: 5,
                                  ),
                                  Text(
                                    '+351${snapshot.data?['patient']['patient']['telephone']}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Container(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.email),
                                  Container(
                                    width: 5,
                                  ),
                                  Flexible(
                                    child: Text(
                                      snapshot.data?['patient']['patient']
                                          ['email'],
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: MediaQuery.of(context).size.height / 2 - 250,
                          decoration: BoxDecoration(
                              color: Color(0xFF787878).withOpacity(0.16),
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          }
        });
  }
}
