import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:byme_flutter_app/utils/user/fetch_user_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

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

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _birthdateController;
  late TextEditingController _addressController;
  late String _speciality;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLoadingImage = false;
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _birthdateController = TextEditingController();
    _addressController = TextEditingController();
    _speciality = '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _birthdateController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<UploadTask> upload(String path) async {
    File file = File(path);
    try {
      String ref = 'images/img-${DateTime.now().toString()}.jpg';
      UploadTask uploadTask = storage.ref(ref).putFile(file);
      return uploadTask;
    } on FirebaseException catch (e) {
      print('Erro ao fazer upload: ${e.code}');
      throw e; // Lança a exceção para ser tratada fora desta função
    }
  }

  pickAndUploadImage() async {
    XFile? file = await getImage();
    if (file != null) {
      await upload(file.path);
      UploadTask task = await upload(file.path);

      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if (snapshot.state == TaskState.running) {
          setState(() {
            _isLoadingImage = true;
          });
        } else if (snapshot.state == TaskState.success) {
          setState(() {
            _isLoadingImage = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: fetchUserData(context, 'all', getDate(), null, null, null),
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
          if (_nameController.text.isEmpty) {
            _nameController.text =
                snapshot.data?['user']['doctor']['fullname'] ?? '';
          }
          if (_phoneController.text.isEmpty) {
            _phoneController.text =
                snapshot.data?['user']['doctor']['telephone'].toString() ?? '';
          }
          if (_birthdateController.text.isEmpty) {
            _birthdateController.text =
                snapshot.data?['user']['doctor']['birthdate'].toString() ?? '';
          }
          if (_addressController.text.isEmpty) {
            _addressController.text =
                snapshot.data?['user']['doctor']['address'] ?? '';
          }
          if (_speciality.isEmpty) {
            _speciality = snapshot.data?['user']['doctor']['speciality'] ?? '';
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Informações Pessoais',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 20, right: 20),
                    width: 400,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 6,
                                    child: Text(
                                      'Mudar Imagem de Perfil',
                                    )),
                                _isLoadingImage
                                    ? Center(
                                        child: SizedBox(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          pickAndUploadImage();
                                        },
                                        icon: Icon(Icons.add_a_photo)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            enabled: _isLoading == false,
                            validator: (name) {
                              if (name == null || name.isEmpty) {
                                return 'Insira seu nome';
                              }
                              return null;
                            },
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Nome Completo',
                              filled: true,
                              fillColor: Colors.grey[200],
                              labelStyle: TextStyle(fontSize: 13),
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            enabled: _isLoading == false,
                            validator: (phone) {
                              if (phone == null || phone.isEmpty) {
                                return 'Insira seu número de telefone';
                              }
                              return null;
                            },
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'Número de Telemóvel',
                              filled: true,
                              fillColor: Colors.grey[200],
                              labelStyle: TextStyle(fontSize: 13),
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            enabled: _isLoading == false,
                            readOnly: true,
                            onTap: () {
                              _selectDate(_birthdateController);
                            },
                            controller: _birthdateController,
                            decoration: InputDecoration(
                              labelText: 'Data de Nascimento',
                              filled: true,
                              fillColor: Colors.grey[200],
                              labelStyle: TextStyle(fontSize: 13),
                              prefixIcon: Icon(Icons.calendar_today),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            enabled: _isLoading == false,
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: 'Morada',
                              filled: true,
                              fillColor: Colors.grey[200],
                              labelStyle: TextStyle(fontSize: 13),
                              prefixIcon: Icon(Icons.location_on),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Especialidade',
                              filled: true,
                              fillColor: Colors.grey[200],
                              prefixIcon: Icon(Icons.badge_rounded),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            value: _speciality,
                            items: _specialties.map((String specialty) {
                              return DropdownMenuItem<String>(
                                value: specialty,
                                child: Text(specialty),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _speciality = newValue!;
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
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: 10, bottom: 30, left: 20, right: 20),
                width: 400,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 25)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xff672D6F)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isLoading ? '' : 'Salvar Alterações',
                          style: const TextStyle(fontSize: 18),
                        ),
                        if (_isLoading)
                          const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                      ]),
                ),
              )
            ],
          );
        }
      },
    );
  }

  Future<void> _selectDate(_birthdate) async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2025),
    );

    if (_picked != null) {
      setState(() {
        _birthdate.text = DateFormat('yyyy-MM-dd').format(_picked);
      });
    }
  }
}
