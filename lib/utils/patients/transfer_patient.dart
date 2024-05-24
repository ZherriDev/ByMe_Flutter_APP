import 'dart:async';

import 'package:byme_flutter_app/utils/patients/confirm_transfer.dart';
import 'package:byme_flutter_app/utils/user/get_doctors_data.dart';
import 'package:flutter/material.dart';

class TransferPatient extends StatefulWidget {
  final BuildContext context;
  final int patientId;
  final PageController pageController;

  const TransferPatient(
      {Key? key,
      required this.context,
      required this.patientId,
      required this.pageController})
      : super(key: key);

  @override
  State<TransferPatient> createState() => _TransferPatientState();
}

class _TransferPatientState extends State<TransferPatient> {
  final _formKey = GlobalKey<FormState>();
  final search = TextEditingController();
  Future<Map<String, dynamic>?> futureDoctors = getDoctorsData(null);
  String? query;

  void fetchDoctorsData(String? query) async {
    setState(() {
      futureDoctors = getDoctorsData(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formKey,
          child: TextFormField(
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  query = null;
                });
              } else {
                setState(() {
                  query = value;
                });
              }
              fetchDoctorsData(query);
            },
            controller: search,
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.tertiary,
              label: const Text('Pesquisar doutor'),
              hintText: 'Pesquise por um doutor',
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
      content: Container(
        height: 400,
        child: FutureBuilder<Map<String, dynamic>?>(
          future: futureDoctors,
          builder: (context, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (futureSnapshot.hasError || futureSnapshot.data == null) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Text('Erro ao carregar dados dos doutores'),
                ),
              );
            } else {
              List<dynamic> doctors = futureSnapshot.data?['doctors'];

              if (doctors.length >= 1)
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                      itemCount: doctors.length,
                      itemBuilder: (context, index) {
                        int doctorId = doctors[index]['doctor_id'];
                        String fullname = doctors[index]['fullname'];
                        String photo = doctors[index]['photo'];
                        if (photo == 'assets/images/user.png') {
                          photo =
                              'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg';
                        }
                        String speciality = doctors[index]['speciality'];

                        return ListTile(
                          onTap: () {
                            Navigator.of(widget.context).pop();
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmTransfer(
                                    context: context,
                                    fullname: fullname,
                                    patientId: widget.patientId,
                                    doctorId: doctorId,
                                    pageController: widget.pageController,
                                  );
                                });
                          },
                          leading: CircleAvatar(
                            backgroundColor: Color(0xff672D6F),
                            backgroundImage: NetworkImage(photo),
                          ),
                          title: Text(fullname),
                          subtitle: Text(speciality),
                        );
                      }),
                );
              else
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Text('Nenhum doutor encontrado'),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
