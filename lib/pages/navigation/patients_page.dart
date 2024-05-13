import 'package:byme_flutter_app/utils/patients/get_patients_data.dart';
import 'package:byme_flutter_app/utils/token/read_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  final _formKey2 = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final telephoneController = TextEditingController();
  final emailController = TextEditingController();
  String? sex;
  final birthdateController = TextEditingController();
  final processnumberController = TextEditingController();
  final addressController = TextEditingController();
  final postalcodeController = TextEditingController();
  final townController = TextEditingController();
  final NIFController = TextEditingController();
  final SNSController = TextEditingController();
  bool isLoading = false;
  String message = '';

  final List<String> _order = [
    'A-Z',
    'Recente',
  ];

  final List<String> _state = [
    'In Treatment',
    'Awaiting Treatment',
    'Completed Treatment'
  ];

  final List<String> _sex = ['Feminino', 'Masculino'];

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

  Future<bool?> addPatient(name, telephone, email, sex, birthdate,
      processnumber, address, postalcode, town, nif, sns) async {
    Map<String, dynamic>? userStorage = await readToken();
    String token = userStorage?['token'];
    int doctorId = userStorage?['doctor_id'];

    var url =
        Uri.parse('https://api-py-byme.onrender.com/patient/insert_patient');
    var body = {
      "doctor_id": doctorId,
      "name": name,
      "telephone": telephone,
      "email": email,
      "sex": sex,
      "birthdate": birthdate,
      "processnumber": processnumber,
      "address": address,
      "postalcode": postalcode,
      "town": town,
      "nif": nif,
      "sns": sns
    };
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: header,
      );
      switch (response.statusCode) {
        case 201:
          return true;
        case 400:
          setState(() {
            message =
                'Os tipos de dados introduzidos não correspondem aos que foram pedidos.';
          });
          return false;
        case 429:
          setState(() {
            message = 'Muitas requisições, tente novamente em 1 minuto.';
          });
          return false;
        case 500:
          setState(() {
            message = 'Algo correu mal.';
          });
          return false;
      }
    } catch (error) {
      setState(() {
        message = 'Erro de conexão. Verifique sua conexão com a internet.';
      });
      return false;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return null;
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
            padding: EdgeInsets.all(14),
            child: Column(
              children: [
                Form(
                  key: _formKey1,
                  child: Row(
                    children: [
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
                        flex: 2,
                        child: TextFormField(
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
                    ],
                  ),
                ),
                Container(
                  height: 10,
                ),
                if (patients.length >= 1)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 440,
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
                              widget.patientPageID(patient_id);
                              widget.pageController.jumpToPage(6);
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
                      height: MediaQuery.of(context).size.height - 440,
                      child: Center(
                        child: Text('Nenhum paciente encontrado'),
                      )),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    backgroundColor: Color(0xff672D6F),
                    child: Icon(
                      Icons.person_add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Container(
                                padding: EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Color(0xff672D6F),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  'Novo Paciente',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              content: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 400,
                                child: Form(
                                  key: _formKey2,
                                  child: ListView(
                                    children: [
                                      TextFormField(
                                        enabled: isLoading == false,
                                        controller: nameController,
                                        validator: (name) {
                                          if (name == null || name.isEmpty) {
                                            return 'Insira o nome completo do paciente';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[300],
                                          prefixIcon: const Icon(Icons.person),
                                          label: const Text('Nome completo'),
                                          hintText: 'Nome completo do paciente',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        enabled: isLoading == false,
                                        controller: telephoneController,
                                        keyboardType: TextInputType.number,
                                        validator: (telephone) {
                                          if (telephone == null ||
                                              telephone.isEmpty) {
                                            return 'Insira o número de telefone do paciente';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[300],
                                          prefixIcon: const Icon(Icons.call),
                                          label: const Text('Telefone'),
                                          hintText:
                                              'Número de telefone do paciente',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        enabled: isLoading == false,
                                        controller: emailController,
                                        validator: (email) {
                                          if (email == null || email.isEmpty) {
                                            return 'Insira o email do paciente';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[300],
                                          prefixIcon: const Icon(Icons.email),
                                          label: const Text('E-mail'),
                                          hintText: 'Email do paciente',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 10,
                                      ),
                                      DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[300],
                                          prefixIcon: Icon(Icons.face),
                                          label: const Text('Sexo'),
                                          hintText: 'Sexo do paciente',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        value: sex,
                                        items: _sex.map((String sex) {
                                          return DropdownMenuItem<String>(
                                            value: sex,
                                            child: Text(
                                              sex,
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            sex = newValue!;
                                          });
                                        },
                                        validator: (sex) {
                                          if (sex == null) {
                                            return 'Por favor, selecione o sexo do paciente';
                                          }
                                          return null;
                                        },
                                      ),
                                      Container(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        enabled: isLoading == false,
                                        controller: birthdateController,
                                        keyboardType: TextInputType.number,
                                        validator: (birthdate) {
                                          if (birthdate == null ||
                                              birthdate.isEmpty) {
                                            return 'Insira a data de nascimento do paciente';
                                          }
                                          RegExp dateRegex =
                                              RegExp(r'^\d{4}-\d{2}-\d{2}$');
                                          if (!dateRegex.hasMatch(birthdate)) {
                                            return 'Formato de data inválido (YYYY-MM-DD)';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[300],
                                          prefixIcon:
                                              const Icon(Icons.calendar_month),
                                          label:
                                              const Text('Data de nascimento'),
                                          hintText: 'YYYY-MM-DD',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        enabled: isLoading == false,
                                        controller: processnumberController,
                                        validator: (processnumber) {
                                          if (processnumber == null ||
                                              processnumber.isEmpty) {
                                            return 'Insira o número de processo do paciente';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[300],
                                          prefixIcon: const Icon(Icons.numbers),
                                          label:
                                              const Text('Número de processo'),
                                          hintText:
                                              'Número de processo do paciente',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        enabled: isLoading == false,
                                        controller: addressController,
                                        validator: (address) {
                                          if (address == null ||
                                              address.isEmpty) {
                                            return 'Insira a morada do paciente';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[300],
                                          prefixIcon: const Icon(Icons.home),
                                          label: const Text('Morada'),
                                          hintText: 'Morada do paciente',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        enabled: isLoading == false,
                                        keyboardType: TextInputType.number,
                                        controller: postalcodeController,
                                        validator: (postalcode) {
                                          if (postalcode == null ||
                                              postalcode.isEmpty) {
                                            return 'Insira o código postal do paciente';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[300],
                                          prefixIcon: const Icon(Icons.numbers),
                                          label: const Text('Código Postal'),
                                          hintText: '####-###',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        enabled: isLoading == false,
                                        controller: townController,
                                        validator: (town) {
                                          if (town == null || town.isEmpty) {
                                            return 'Insira a cidade do paciente';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[300],
                                          prefixIcon:
                                              const Icon(Icons.location_on),
                                          label: const Text('Cidade'),
                                          hintText: 'Cidade do paciente',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        enabled: isLoading == false,
                                        keyboardType: TextInputType.number,
                                        controller: NIFController,
                                        validator: (NIF) {
                                          if (NIF == null || NIF.isEmpty) {
                                            return 'Insira o NIF do paciente';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[300],
                                          prefixIcon: const Icon(Icons.badge),
                                          label: const Text(
                                              'Nº de Identificação Fiscal'),
                                          hintText: 'NIF do paciente',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        enabled: isLoading == false,
                                        keyboardType: TextInputType.number,
                                        controller: SNSController,
                                        validator: (SNS) {
                                          if (SNS == null || SNS.isEmpty) {
                                            return 'Insira o SNS do paciente';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[300],
                                          prefixIcon: const Icon(Icons.numbers),
                                          label: const Text(
                                              'Nº do Serviço Nacional de Saúde'),
                                          hintText: 'SNS do paciente',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _formKey2.currentState!.reset();
                                          Navigator.of(context).pop();
                                        },
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all<
                                                  EdgeInsets>(
                                              const EdgeInsets.symmetric(
                                                  vertical: 15,
                                                  horizontal: 25)),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color(0xff672D6F)),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Cancelar',
                                          style: const TextStyle(fontSize: 18),
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
                                          if (_formKey2.currentState!
                                              .validate()) {
                                            setState(() {
                                              isLoading = true;
                                              message = "";
                                            });
                                            addPatient(
                                              nameController.text,
                                              telephoneController.text,
                                              emailController.text,
                                              sex,
                                              birthdateController.text,
                                              processnumberController.text,
                                              addressController.text,
                                              postalcodeController.text,
                                              townController.text,
                                              NIFController.text,
                                              SNSController.text,
                                            ).then((success) {
                                              if (success != null &&
                                                  success != false) {
                                                _formKey2.currentState!.reset();
                                                Navigator.of(context).pop();
                                                reloadPage();
                                              }
                                            });
                                          }
                                        },
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all<
                                                  EdgeInsets>(
                                              const EdgeInsets.symmetric(
                                                  vertical: 15,
                                                  horizontal: 25)),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color(0xff672D6F)),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                isLoading ? '' : 'Adicionar',
                                                style: const TextStyle(
                                                    fontSize: 18),
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
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.red),
                                    child: Text(
                                      message,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
