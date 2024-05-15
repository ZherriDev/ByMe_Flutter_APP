import 'package:byme_flutter_app/utils/patients/fetch_patient_data.dart';
import 'package:byme_flutter_app/utils/token/read_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  final _formKey1 = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController telephoneController;
  late TextEditingController emailController;
  late String? sex;
  late TextEditingController birthdateController;
  late TextEditingController processnumberController;
  late TextEditingController addressController;
  late TextEditingController postalcodeController;
  late TextEditingController townController;
  late TextEditingController NIFController;
  late TextEditingController SNSController;
  bool isLoading = false;
  String message = '';

  void reloadPage() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    telephoneController = TextEditingController();
    emailController = TextEditingController();
    sex = '';
    birthdateController = TextEditingController();
    processnumberController = TextEditingController();
    addressController = TextEditingController();
    postalcodeController = TextEditingController();
    townController = TextEditingController();
    NIFController = TextEditingController();
    SNSController = TextEditingController();
  }

  Future<bool?> updatePatient(patientId, name, telephone, email, sex, birthdate,
      processnumber, address, postalcode, town, nif, sns) async {
    Map<String, dynamic>? userStorage = await readToken();
    String token = userStorage?['token'];

    var url =
        Uri.parse('https://api-py-byme.onrender.com/patient/update_patient');
    var body = {
      "patient_id": patientId,
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
      final response = await http.patch(
        url,
        body: jsonEncode(body),
        headers: header,
      );
      switch (response.statusCode) {
        case 200:
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
            final List<String> _sex = ['Feminino', 'Masculino'];
            List<dynamic> modules = snapshot.data?['modules']['modules'];
            Map<String, dynamic> patient = snapshot.data?['patient']['patient'];

            return SingleChildScrollView(
              padding: EdgeInsets.only(left: 14, right: 14, bottom: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          nameController.text = patient['name'];
                          telephoneController.text =
                              patient['telephone'].toString();
                          emailController.text = patient['email'];
                          sex = patient['sex'];
                          birthdateController.text = patient['birthdate'];
                          processnumberController.text =
                              patient['processnumber'];
                          addressController.text = patient['address'];
                          postalcodeController.text = patient['postalcode'];
                          townController.text = patient['town'];
                          NIFController.text = patient['nif'].toString();
                          SNSController.text = patient['sns'].toString();
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      'Editar Paciente',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  content: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 400,
                                    child: Form(
                                      key: _formKey1,
                                      child: ListView(
                                        children: [
                                          Container(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            enabled: isLoading == false,
                                            controller: nameController,
                                            validator: (name) {
                                              if (name == null ||
                                                  name.isEmpty) {
                                                return 'Insira o nome completo do paciente';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.grey[400]
                                                  ?.withOpacity(0.3),
                                              prefixIcon:
                                                  const Icon(Icons.person),
                                              label:
                                                  const Text('Nome completo'),
                                              hintText:
                                                  'Nome completo do paciente',
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
                                              fillColor: Colors.grey[400]
                                                  ?.withOpacity(0.3),
                                              prefixIcon:
                                                  const Icon(Icons.call),
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
                                              if (email == null ||
                                                  email.isEmpty) {
                                                return 'Insira o email do paciente';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.grey[400]
                                                  ?.withOpacity(0.3),
                                              prefixIcon:
                                                  const Icon(Icons.email),
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
                                              fillColor: Colors.grey[400]
                                                  ?.withOpacity(0.3),
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
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                sex = newValue;
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
                                              RegExp dateRegex = RegExp(
                                                  r'^\d{4}-\d{2}-\d{2}$');
                                              if (!dateRegex
                                                  .hasMatch(birthdate)) {
                                                return 'Formato de data inválido (YYYY-MM-DD)';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.grey[400]
                                                  ?.withOpacity(0.3),
                                              prefixIcon: const Icon(
                                                  Icons.calendar_month),
                                              label: const Text(
                                                  'Data de nascimento'),
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
                                              fillColor: Colors.grey[400]
                                                  ?.withOpacity(0.3),
                                              prefixIcon:
                                                  const Icon(Icons.numbers),
                                              label: const Text(
                                                  'Número de processo'),
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
                                              fillColor: Colors.grey[400]
                                                  ?.withOpacity(0.3),
                                              prefixIcon:
                                                  const Icon(Icons.home),
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
                                              fillColor: Colors.grey[400]
                                                  ?.withOpacity(0.3),
                                              prefixIcon:
                                                  const Icon(Icons.numbers),
                                              label:
                                                  const Text('Código Postal'),
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
                                              if (town == null ||
                                                  town.isEmpty) {
                                                return 'Insira a cidade do paciente';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.grey[400]
                                                  ?.withOpacity(0.3),
                                              prefixIcon: const Icon(
                                                  Icons.location_city),
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
                                              fillColor: Colors.grey[400]
                                                  ?.withOpacity(0.3),
                                              prefixIcon:
                                                  const Icon(Icons.badge),
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
                                              fillColor: Colors.grey[400]
                                                  ?.withOpacity(0.3),
                                              prefixIcon:
                                                  const Icon(Icons.numbers),
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
                                              Navigator.of(context).pop();
                                            },
                                            style: ButtonStyle(
                                              padding: MaterialStateProperty
                                                  .all<EdgeInsets>(
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 15,
                                                          horizontal: 25)),
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      const Color(0xff672D6F)),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              'Cancelar',
                                              style:
                                                  const TextStyle(fontSize: 18),
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
                                              if (_formKey1.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  isLoading = true;
                                                  message = "";
                                                });
                                                updatePatient(
                                                  widget.patientId,
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
                                                  if (success == true) {
                                                    Navigator.of(context).pop();
                                                    reloadPage();
                                                  }
                                                });
                                              }
                                            },
                                            style: ButtonStyle(
                                              padding: MaterialStateProperty
                                                  .all<EdgeInsets>(
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 15,
                                                          horizontal: 25)),
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      const Color(0xff672D6F)),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    isLoading ? '' : 'Salvar',
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
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.red),
                                        child: Text(
                                          message,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
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
                    height: 20,
                  ),
                  Text(
                    'Módulos do Paciente:',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  if (modules.length >= 1)
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: MediaQuery.of(context).size.height - 650,
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
                        )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton.extended(
                        backgroundColor: Color(0xff672D6F),
                        foregroundColor: Colors.white,
                        onPressed: () {},
                        label: Row(
                          children: [
                            Icon(Icons.transfer_within_a_station),
                            Container(
                              width: 5,
                            ),
                            Text(
                              'Transferir Paciente',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      FloatingActionButton(
                        backgroundColor: Color(0xff672D6F),
                        foregroundColor: Colors.white,
                        onPressed: () {},
                        child: Icon(Icons.document_scanner),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        });
  }
}
