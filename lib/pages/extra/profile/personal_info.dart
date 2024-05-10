import 'package:byme_flutter_app/utils/user/fetch_user_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PersonalInfo extends StatefulWidget {
  final PageController pageController;

  const PersonalInfo({Key? key, required this.pageController})
      : super(key: key);

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  String getDate() {
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;
    int day = now.day;

    String todayDate = '$year-$month-$day';
    return todayDate;
  }

  final List<String> _specialties = [
    'Clínico Geral',
    'Cardiologista',
    'Dermatologista',
    'Endocrinologista',
    'Gastroenterologista',
    'Ginecologista',
    'Neurologista',
    'Ortopedista',
    'Pediatra',
    'Psiquiatra',
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
        future: fetchUserData(context, 'all', getDate(), null, null),
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
            final name = TextEditingController(
              text: snapshot.data?['user']['doctor']['fullname'] ?? ' ',
            );
            final phone = TextEditingController(
              text: snapshot.data?['user']['doctor']['telephone'].toString() ??
                  '',
            );

            final _birthdate = TextEditingController(
                text:
                    snapshot.data?['user']['doctor']['birthdate'].toString() ??
                        '');
            print(_birthdate);
            String speciality =
                snapshot.data?['user']['doctor']['speciality'] ?? ' ';
            final address = TextEditingController(
              text: snapshot.data?['user']['doctor']['address'] ?? ' ',
            );

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Informações Pessoais',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 20, right: 20),
                    height: 450,
                    width: 400,
                    child: Form(
                        child: Column(
                      children: [
                        TextFormField(
                          validator: (name) {
                            if (name == null) {
                              return 'Insira seu nome';
                            }
                            return null;
                          },
                          controller: name,
                          decoration: InputDecoration(
                              labelText: 'Nome Completo',
                              filled: true,
                              fillColor: Colors.grey[300],
                              labelStyle: TextStyle(fontSize: 13),
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          validator: (phone) {
                            if (phone == null) {
                              return 'Insira seu número de telemovel';
                            }
                            return null;
                          },
                          controller: phone,
                          decoration: InputDecoration(
                              labelText: 'Número de Telemovel',
                              filled: true,
                              fillColor: Colors.grey[300],
                              labelStyle: TextStyle(fontSize: 13),
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          readOnly: true,
                          onTap: () {
                            _selectDate(_birthdate);
                          },
                          controller: _birthdate,
                          decoration: InputDecoration(
                              labelText: 'Data de Nascimento',
                              filled: true,
                              fillColor: Colors.grey[300],
                              labelStyle: TextStyle(fontSize: 13),
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            prefixIcon: const Icon(Icons.badge_rounded),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          value: speciality,
                          items: _specialties.map((String specialty) {
                            return DropdownMenuItem<String>(
                              value: specialty,
                              child: Text(specialty),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              speciality = newValue!;
                            });
                          },
                          validator: (speciality) {
                            if (speciality == null) {
                              return 'Por favor, selecione uma especialidade';
                            }
                            return null;
                          },
                        ),
                      ],
                    )),
                  )
                ],
              ),
            );
          }
        });
  }

  Future<void> _selectDate(_birthdate) async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2025));

    if (_picked != null) {
      setState(() {
        _birthdate.text = _picked.toString().split(" ")[0];
      });
    }
  }
}
