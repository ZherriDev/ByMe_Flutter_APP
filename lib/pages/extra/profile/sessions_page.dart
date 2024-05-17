import 'package:byme_flutter_app/utils/sessions/get_sessions.dart';
import 'package:byme_flutter_app/utils/user/fetch_user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class SessionsPage extends StatefulWidget {
  final PageController pageController;
  const SessionsPage({Key? key, required this.pageController})
      : super(key: key);

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  String getDate() {
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;
    int day = now.day;

    String todayDate = '$year-$month-$day';
    return todayDate;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
        future: getUserSessions(),
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
            List<dynamic> sessions = snapshot.data?['sessions'];
            final currentSession = snapshot.data?['current_session'];
            final sessionsLength = sessions.length;

            sessions.remove(currentSession);

            sessions.sort(
              (a, b) {
                if (a['session_id'] == currentSession) {
                  return -1;
                } else if (b['session_id'] == currentSession) {
                  return 1;
                }
                return 0;
              },
            );

            print(sessions);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 30),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          widget.pageController.jumpToPage(3);
                        },
                        icon: Icon(Icons.arrow_back),
                      ),
                      SizedBox(
                        width: 85,
                      ),
                      Text(
                        'Sessões',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    Text(
                      'Seus Dispositivos: ${sessionsLength}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Efetuas-te Login nesses dispositivos:'),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 480,
                      child: ListView.builder(
                        itemCount: sessionsLength,
                        itemBuilder: (context, index) {
                          String location = sessions[index]['location'];
                          initializeDateFormatting('pt_br');

                          String androidImage =
                              'https://firebasestorage.googleapis.com/v0/b/byme-app-images.appspot.com/o/images%2FIcons%2Fandroid_os_logo_icon_134673.png?alt=media&token=c1a6bab8-0a7c-4ea8-ba11-56647d177d06';
                          String IOSImage =
                              'https://firebasestorage.googleapis.com/v0/b/byme-app-images.appspot.com/o/images%2FIcons%2Fapple.png?alt=media&token=8449c6fc-4c58-4e15-a161-41197843e22e';
                          DateFormat formater =
                              DateFormat('EEE, dd MMM yyyy HH:mm:ss zzz');

                          DateTime date =
                              formater.parse(sessions[index]['date_time']);
                          int day = date.day;
                          String monthName =
                              DateFormat('MMMM', 'pt_BR').format(date);

                          String os = sessions[index]['operational_system'];

                          bool isAndroid = os.contains('Android');

                          return ListTile(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              isAndroid
                                                  ? CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                              androidImage),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                    )
                                                  : CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                              IOSImage),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                    ),
                                              isAndroid
                                                  ? Text(
                                                      'Dispositivo Android',
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    )
                                                  : Text(
                                                      'Dispositivo IOS',
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                            ],
                                          )
                                        ],
                                      ),
                                      content: Container(
                                        height: 100,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Nome do Disposivito: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(sessions[index]['device'])
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Endereço IP: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(sessions[index]
                                                    ['ip_address'])
                                              ],
                                            ),
                                            Text(
                                                '${location}, ${day} de ${monthName}')
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            title: Text(sessions[index]['device']),
                            subtitle:
                                Text('${location}, ${day} de ${monthName}'),
                            trailing: Text(sessions[index]['ip_address']),
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: isAndroid
                                  ? NetworkImage(androidImage)
                                  : NetworkImage(IOSImage),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )
              ],
            );
          }
        });
  }
}
