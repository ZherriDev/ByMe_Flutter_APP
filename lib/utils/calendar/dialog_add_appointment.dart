import 'package:byme_flutter_app/utils/appointment/add_appointment.dart';
import 'package:byme_flutter_app/utils/patients/get_patients_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddAppointment extends StatefulWidget {
  final BuildContext context;
  final PageController pageController;
  final Function() reloadPage;

  const AddAppointment(
      {Key? key,
      required this.context,
      required this.pageController,
      required this.reloadPage})
      : super(key: key);

  @override
  State<AddAppointment> createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  bool isLoading = false;
  String message = "";
  final _formKey = GlobalKey<FormState>();
  final subject = TextEditingController();
  final date = TextEditingController();
  final time = TextEditingController();
  String? patient;
  List<String> patientsNames = [];
  Map<String, int> patientsMap = {};
  Future<Map<String, dynamic>?>? patientsData =
      getPatientsData(null, null, null);

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectDate(dateController) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime(2025),
    );

    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
            color: const Color(0xff672D6F), borderRadius: BorderRadius.circular(10)),
        child: const Text(
          'Nova Consulta',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 315,
        child: FutureBuilder(
            future: patientsData,
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
                snapshot.data?['patients'].forEach((patient) {
                  if (!patientsNames.contains(patient['name'])) {
                    patientsNames.add(patient['name']);
                  }
                  if (!patientsMap.containsKey(patient['name'])) {
                    patientsMap.putIfAbsent(
                        patient['name'], () => patient['patient_id']);
                  }
                });

                return Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.tertiary,
                            prefixIcon: const Icon(Icons.personal_injury),
                            label: const Text('Paciente'),
                            hintText: 'Escolha o paciente',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          value: patient,
                          items: patientsNames.map((String patient) {
                            return DropdownMenuItem<String>(
                              value: patient,
                              child: Container(
                                constraints: const BoxConstraints(maxWidth: 160),
                                child: Text(
                                  patient,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              patient = newValue!;
                            });
                          },
                          validator: (patient) {
                            if (patient == null) {
                              return 'Por favor, selecione o paciente';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          enabled: isLoading == false,
                          controller: subject,
                          validator: (subject) {
                            if (subject == null || subject.isEmpty) {
                              return 'Insira o assunto da consulta';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.tertiary,
                            prefixIcon: const Icon(Icons.subject),
                            label: const Text('Assunto'),
                            hintText: 'Assunto da consulta',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          enabled: isLoading == false,
                          controller: date,
                          readOnly: true,
                          onTap: () {
                              _selectDate(date);
                          },
                          validator: (date) {
                            if (date == null || date.isEmpty) {
                              return 'Insira a data da consulta';
                            }
                            RegExp dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                            if (!dateRegex.hasMatch(date)) {
                              return 'Formato de data inválido (YYYY-MM-DD)';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.tertiary,
                            prefixIcon: const Icon(Icons.calendar_month),
                            label: const Text('Data da consulta'),
                            hintText: 'YYYY-MM-DD',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          enabled: isLoading == false,
                          controller: time,
                          keyboardType: TextInputType.datetime,
                          validator: (time) {
                            if (time == null || time.isEmpty) {
                              return 'Insira a data da consulta';
                            }
                            RegExp timeRegex = RegExp(r'^\d{2}:\d{2}:\d{2}$');
                            if (!timeRegex.hasMatch(time)) {
                              return 'Formato de data inválido (HH:MM:SS)';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.tertiary,
                            prefixIcon: const Icon(Icons.access_time),
                            label: const Text('Hora da consulta'),
                            hintText: 'HH:MM:SS',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
              }
            }),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(widget.context).pop();
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 25)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xff672D6F)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Container(
              width: 5,
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                      message = "";
                    });
                    int patientId = patientsMap[patient]!;

                    addAppointment(
                            patientId, subject.text, date.text, time.text)
                        .then((success) {
                      if (success == true) {
                        _formKey.currentState!.reset();
                        Navigator.of(widget.context).pop();
                        widget.reloadPage();
                      }
                    });
                  }
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 25)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xff672D6F)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    isLoading ? '' : 'Adicionar',
                    style: const TextStyle(fontSize: 18),
                  ),
                  if (isLoading)
                    const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                ]),
              ),
            ),
          ],
        ),
        Container(
          height: 10,
        ),
        Visibility(
          visible: message.isNotEmpty,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: Colors.red),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
