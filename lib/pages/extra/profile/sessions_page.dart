import 'package:byme_flutter_app/provider.dart';
import 'package:byme_flutter_app/utils/sessions/session_alert_dialog.dart';
import 'package:byme_flutter_app/utils/sessions/get_sessions.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

            return Consumer<UIProvider>(
                builder: (context, UIProvider notifier, child) {
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
                                'Sessões do Utilizador',
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
                    height: 15,
                  ),
                  Column(
                    children: [
                      Text(
                        'Seus Dispositivos: ${sessionsLength}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Tens sessão ativa nesses dispositivos:'),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 470,
                        child: ListView.builder(
                          itemCount: sessionsLength,
                          itemBuilder: (context, index) {
                            String location = sessions[index]['location'];
                            initializeDateFormatting('pt_br');

                            String androidImage =
                                'https://firebasestorage.googleapis.com/v0/b/byme-app-images.appspot.com/o/images%2FIcons%2Fandroid_os_logo_icon_134673.png?alt=media&token=c1a6bab8-0a7c-4ea8-ba11-56647d177d06';
                            String IOSImage;

                            if (notifier.isDark) {
                              IOSImage =
                                  'https://firebasestorage.googleapis.com/v0/b/byme-app-images.appspot.com/o/images%2FIcons%2Fapple%20(1).png?alt=media&token=0befbee2-5024-4339-886a-ff1f8032509a';
                            } else {
                              IOSImage =
                                  'https://firebasestorage.googleapis.com/v0/b/byme-app-images.appspot.com/o/images%2FIcons%2Fapple.png?alt=media&token=8449c6fc-4c58-4e15-a161-41197843e22e';
                            }

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
                                      return SessionAlertDialog(
                                        isAndroid: isAndroid,
                                        androidImage: androidImage,
                                        iOSImage: IOSImage,
                                        index: index,
                                        sessions: sessions,
                                        setState: _setState,
                                      );
                                    });
                              },
                              title: Text(sessions[index]['device']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${location}, ${day} de ${monthName}'),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  CurrentSession(index)
                                ],
                              ),
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
            });
          }
        });
  }

  Widget CurrentSession(index) {
    if (index == 0) {
      return Row(
        children: [
          Image.asset(
            'assets/images/success.png',
            width: 20,
          ),
          SizedBox(
            width: 10,
          ),
          Text('Sessão Atual'),
        ],
      );
    } else {
      return Container();
    }
  }

  void _setState() {
    setState(() {});
  }
}
