import 'package:byme_flutter_app/utils/modules/add_module.dart';
import 'package:byme_flutter_app/utils/patients/delete_patient.dart';
import 'package:byme_flutter_app/utils/patients/fetch_patient_data.dart';
import 'package:byme_flutter_app/utils/patients/transfer_patient.dart';
import 'package:byme_flutter_app/utils/patients/update_patient.dart';
import 'package:byme_flutter_app/utils/patients/update_patient_status.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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

class _PatientPageState extends State<PatientPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animation;
  final menuIsOpen = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    super.dispose();
    animation.dispose();
  }

  toggleMenu() {
    menuIsOpen.value ? animation.reverse() : animation.forward();
    menuIsOpen.value = !menuIsOpen.value;
  }

  void reloadPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchPatientData(widget.patientId),
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
            Map<String, dynamic> patient = snapshot.data?['patient']['patient'];

            return Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.only(left: 14, right: 14, bottom: 14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                patient['name'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              patient['processnumber'],
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[600]),
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
                                '${patient["address"]} - ${patient["postalcode"]} - ${patient["town"]}',
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
                                patient["email"],
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
                                '+351${patient["telephone"]}',
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
                        if (modules.length >= 1)
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            height: MediaQuery.of(context).size.height - 570,
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
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
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
                                                      ? 'Terminado'
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
                              height: MediaQuery.of(context).size.height - 570,
                              child: Center(
                                child: Text(
                                    'O paciente ainda não possui módulos adicionados'),
                              ))
                      ],
                    ),
                  ),
                  Positioned(
                      right: 15,
                      bottom: 10,
                      child: SpeedDial(
                        backgroundColor: Color(0xff672D6F),
                        foregroundColor: Colors.white,
                        animatedIcon: AnimatedIcons.menu_close,
                        children: [
                          SpeedDialChild(
                              shape: CircleBorder(),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AddModule(
                                        context: context,
                                        reloadPage: reloadPage,
                                        patientId: widget.patientId,
                                      );
                                    });
                              },
                              backgroundColor: Color(0xff672D6F),
                              foregroundColor: Colors.white,
                              label: 'Adicionar módulo',
                              child: Icon(Icons.document_scanner)),
                          SpeedDialChild(
                              shape: CircleBorder(),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DeletePatient(
                                        context: context,
                                        patientId: widget.patientId,
                                        pageController: widget.pageController,
                                      );
                                    });
                              },
                              backgroundColor: Color(0xff672D6F),
                              foregroundColor: Colors.white,
                              label: 'Excluir paciente',
                              child: Icon(Icons.delete_forever)),
                          SpeedDialChild(
                              shape: CircleBorder(),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return TransferPatient(
                                        context: context,
                                        patientId: widget.patientId,
                                        pageController: widget.pageController,
                                      );
                                    });
                              },
                              backgroundColor: Color(0xff672D6F),
                              foregroundColor: Colors.white,
                              label: 'Transferir paciente',
                              child: Icon(Icons.transfer_within_a_station)),
                          SpeedDialChild(
                              shape: CircleBorder(),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return UpdatePatientStatus(
                                        context: context,
                                        patientId: widget.patientId,
                                        patient: patient,
                                        reloadPage: reloadPage,
                                      );
                                    });
                              },
                              backgroundColor: Color(0xff672D6F),
                              foregroundColor: Colors.white,
                              label: 'Alterar estado do paciente',
                              child: Icon(Icons.change_circle)),
                          SpeedDialChild(
                              shape: CircleBorder(),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return UpdatePatient(
                                          context: context,
                                          patientId: widget.patientId,
                                          patient: patient,
                                          reloadPage: reloadPage);
                                    });
                              },
                              backgroundColor: Color(0xff672D6F),
                              foregroundColor: Colors.white,
                              label: 'Editar paciente',
                              child: Icon(Icons.edit_square)),
                        ],
                      )),
                ],
              ),
            );
          }
        });
  }
}
