import 'dart:io';
import 'package:byme_flutter_app/utils/user/fetch_user_data.dart';
import 'package:byme_flutter_app/utils/user/update_data.dart';
import 'package:byme_flutter_app/utils/user/update_image.dart';
import 'package:byme_flutter_app/utils/widgets/buttom_widget.dart';
import 'package:byme_flutter_app/utils/widgets/change_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PersonalInfo extends StatefulWidget {
  final PageController pageController;
  final Function(String) reloadPhoto;

  const PersonalInfo(
      {Key? key, required this.pageController, required this.reloadPhoto})
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

  final List<String> _sexes = ['Masculino', 'Feminino'];

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _birthdateController;
  late TextEditingController _addressController;
  late String _speciality;
  late String _sex;
  late String _currentImage;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _birthdateController = TextEditingController();
    _addressController = TextEditingController();
    _speciality = '';
    _sex = '';
    _currentImage = '';
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

  Future<String> upload(String path) async {
    File file = File(path);
    try {
      String ref = 'images/img-${DateTime.now().toString()}.jpg';
      await storage.ref(ref).putFile(file);
      UploadTask uploadTask = storage.ref(ref).putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      print('Erro ao fazer upload: ${e.code}');
      throw e;
    }
  }

  pickAndUploadImage() async {
    XFile? file = await getImage();
    if (file != null) {
      String downloadUrl = await upload(file.path);

      int _phoneValue = int.parse(_phoneController.text);
      updateImage(
        _nameController.text,
        _phoneValue,
        _birthdateController.text,
        _addressController.text,
        _speciality,
        downloadUrl,
        _sex,
      ).then((succes) {
        if (succes) {
          widget.reloadPhoto(downloadUrl);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: fetchUserData('all', getDate(), null, null, null),
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
          if (_sex.isEmpty) {
            _sex = snapshot.data?['user']['doctor']['sex'];
          }
          if (_currentImage.isEmpty) {
            _currentImage = snapshot.data?['user']['doctor']['photo'];
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          widget.pageController.jumpToPage(3);
                        },
                        icon: Icon(Icons.arrow_back),
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 45),
                          Text(
                            'Informações Pessoais',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                          ChangeImage(pickAndUploadImage: pickAndUploadImage),
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
                              fillColor:
                                  Theme.of(context).colorScheme.secondary,
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
                              fillColor:
                                  Theme.of(context).colorScheme.secondary,
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
                              fillColor:
                                  Theme.of(context).colorScheme.secondary,
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
                              fillColor:
                                  Theme.of(context).colorScheme.secondary,
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
                              fillColor:
                                  Theme.of(context).colorScheme.secondary,
                              prefixIcon:
                                  Icon(Icons.medical_information_rounded),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            value: _speciality,
                            items: _specialties.map((String specialty) {
                              return DropdownMenuItem<String>(
                                value: specialty,
                                child: Text(
                                  specialty,
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal),
                                ),
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
                          SizedBox(
                            height: 15,
                          ),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Sexo',
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.secondary,
                              prefixIcon: Icon(Icons.face),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            value: _sex,
                            items: _sexes.map((String sex) {
                              return DropdownMenuItem<String>(
                                value: sex,
                                child: Text(
                                  sex,
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _sex = newValue!;
                              });
                            },
                            validator: (sex) {
                              if (sex == null) {
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
              SaveButton(
                formKey: _formKey,
                nameController: _nameController,
                phoneController: _phoneController,
                birthdateController: _birthdateController,
                addressController: _addressController,
                speciality: _speciality,
                currentImage: _currentImage,
                sex: _sex,
                updateData: updateData,
                showSuccessPopUp: _showSuccessPopUp,
                buttonText: 'Salvar Alterações', // Texto do botão definido aqui
              ),
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

  void _showSuccessPopUp(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: SizedBox(
            width: 150,
            height: 150,
            child: Image.asset('assets/images/success.png'),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
