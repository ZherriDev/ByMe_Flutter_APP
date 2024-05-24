import 'package:byme_flutter_app/utils/patients/get_patients_data.dart';
import 'package:byme_flutter_app/utils/patients/insert_patient.dart';
import 'package:flutter/material.dart';

class PatientsPage extends StatefulWidget {
  final PageController pageController;
  final Function(int) patientPageID;

  const PatientsPage({
    Key? key,
    required this.pageController,
    required this.patientPageID,
  }) : super(key: key);

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  final _formKey1 = GlobalKey<FormState>();
  final search = TextEditingController();
  String order = 'A-Z';
  String state = 'Awaiting Treatment';

  final List<String> _order = [
    'A-Z',
    'Recente',
  ];

  final List<String> _state = [
    'In Treatment',
    'Awaiting Treatment',
    'Completed Treatment'
  ];

  Widget iconList(state) {
    if (state == 'In Treatment') {
      return Icon(Icons.healing);
    } else if (state == 'Awaiting Treatment') {
      return Icon(Icons.access_time);
    } else if (state == 'Completed Treatment') {
      return Icon(Icons.check_circle);
    }
    return Icon(Icons.circle);
  }

  Future<Map<String, dynamic>?> fetchPatientsData(
      String? search, order, state) async {
    return await getPatientsData(search, order, state);
  }

  @override
  Widget build(BuildContext context) {
    void reloadPage() {
      setState(() {});
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 14, right: 14, bottom: 14),
              child: Column(
                children: [
                  Container(
                    height: 5,
                  ),
                  Form(
                    key: _formKey1,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.secondary,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            value: state,
                            items: _state.map((String state) {
                              return DropdownMenuItem<String>(
                                value: state,
                                child: iconList(state),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                state = newValue!;
                              });
                            },
                          ),
                        ),
                        Container(
                          width: 5,
                        ),
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.secondary,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            value: order,
                            items: _order.map((String order) {
                              return DropdownMenuItem<String>(
                                value: order,
                                child: Text(
                                  order,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                order = newValue!;
                              });
                            },
                          ),
                        ),
                        Container(
                          width: 5,
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            onChanged: (value) => reloadPage(),
                            controller: search,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.secondary,
                              label: const Text('Pesquisar paciente'),
                              hintText: 'Pesquise por um paciente',
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.healing),
                      Text('Em tratamento'),
                      Container(
                        width: 10,
                      ),
                      Icon(Icons.access_time),
                      Text('Aguardando tratamento'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle),
                      Text('Tratamento concluído'),
                    ],
                  ),
                  Container(
                    height: 10,
                  ),
                  FutureBuilder<Map<String, dynamic>?>(
                    future: fetchPatientsData(
                        search.text.isNotEmpty ? search.text : null,
                        order,
                        state),
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
                        List<dynamic> patients = snapshot.data?['patients'];

                        if (patients.length >= 1) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height - 425,
                            child: ListView.builder(
                                itemCount: patients.length,
                                itemBuilder: (context, index) {
                                  int patient_id =
                                      patients[index]['patient_id'];
                                  String image =
                                      'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg';
                                  String name = patients[index]['name'];
                                  String email = patients[index]['email'];
                                  String processnumber =
                                      patients[index]['processnumber'];

                                  return ListTile(
                                    onTap: () {
                                      widget.patientPageID(patient_id);
                                      widget.pageController.jumpToPage(6);
                                    },
                                    leading: CircleAvatar(
                                      backgroundColor: Color(0xff672D6F),
                                      backgroundImage: NetworkImage(image),
                                    ),
                                    title: Text(name),
                                    subtitle: Text(email),
                                    trailing: Text(processnumber),
                                  );
                                }),
                          );
                        } else {
                          return Container(
                            width: MediaQuery.of(context).size.width - 40,
                            height: MediaQuery.of(context).size.height - 425,
                            child: Center(
                              child: Text('Nenhum paciente encontrado'),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 15,
            bottom: 10,
            child: FloatingActionButton(
              shape: CircleBorder(),
              backgroundColor: Color(0xff672D6F),
              child: Icon(
                Icons.person_add,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return InsertPatient(
                          context: context, reloadPage: reloadPage);
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
