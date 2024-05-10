import 'package:byme_flutter_app/pages/extra/patients/patient_page.dart';
import 'package:byme_flutter_app/utils/patients/get_patients_data.dart';
import 'package:flutter/material.dart';

class PatientsPage extends StatefulWidget {
  final PageController pageController;

  const PatientsPage({Key? key, required this.pageController})
      : super(key: key);

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  final _formKey = GlobalKey<FormState>();
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

  @override
  Widget build(BuildContext context) {
    void reloadPage() {
      setState(() {});
    }

    return FutureBuilder<Map<String, dynamic>?>(
      future: getPatientsData(
          search.text.isNotEmpty ? search.text : null, order, state),
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

          return Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          // enabled: isLoading == false,
                          controller: search,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () => reloadPage(),
                            ),
                            label: const Text('Pesquisar paciente'),
                            hintText: 'Pesquise por um paciente',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
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
                            fillColor: Colors.grey[200],
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
                                    fontSize: 10, fontWeight: FontWeight.bold),
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
                        flex: 1,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
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
                    ],
                  ),
                ),
                Container(
                  height: 10,
                ),
                if (patients.length >= 1)
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: MediaQuery.of(context).size.height - 373,
                    child: ListView.builder(
                        itemCount: patients.length,
                        itemBuilder: (context, index) {
                          int patient_id = patients[index]['patient_id'];
                          String image =
                              'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg';
                          String name = patients[index]['name'];
                          String email = patients[index]['email'];
                          String processnumber =
                              patients[index]['processnumber'];

                          return ListTile(
                            onTap: () {
                              widget.pageController.jumpToPage(6);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatientPage(
                                    patientId: patient_id,
                                    pageController: widget.pageController,
                                  ),
                                ),
                              );
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(image),
                            ),
                            title: Text(name),
                            subtitle: Text(email),
                            trailing: Text(processnumber),
                          );
                        }),
                  )
                else
                  Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: MediaQuery.of(context).size.height - 373,
                      child: Center(
                        child: Text('Nenhum paciente encontrado'),
                      ))
              ],
            ),
          );
        }
      },
    );
  }
}
