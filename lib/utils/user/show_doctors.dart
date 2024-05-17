import 'package:flutter/material.dart';
import 'package:byme_flutter_app/utils/user/get_doctors_data.dart';

class ShowDoctors extends StatefulWidget {
  final BuildContext context;
  final int patientId;
  final TextEditingController search;
  final PageController pageController;

  const ShowDoctors(
      {Key? key,
      required this.context,
      required this.patientId,
      required this.search,
      required this.pageController})
      : super(key: key);

  @override
  State<ShowDoctors> createState() => _ShowDoctorsState();
}

class _ShowDoctorsState extends State<ShowDoctors> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 400,
        child: FutureBuilder(
          future: getDoctorsData(widget.search.text.isNotEmpty ? widget.search.text : null),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError || snapshot.data == null) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Text('Erro ao carregar dados dos doutores'),
                ),
              );
            } else {
              List<dynamic> doctors = snapshot.data?['doctors'];

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
                        String speciality = doctors[index]['speciality'];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.purple,
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
      );
  }
}