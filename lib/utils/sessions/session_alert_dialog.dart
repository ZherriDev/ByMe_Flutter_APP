import 'package:byme_flutter_app/utils/sessions/update_session.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SessionAlertDialog extends StatefulWidget {
  final bool isAndroid;
  final String androidImage;
  final String iOSImage;
  final int index;
  final List<dynamic> sessions;
  final void Function() setState;

  const SessionAlertDialog({
    Key? key, 
    required this.isAndroid,
    required this.androidImage,
    required this.iOSImage,
    required this.index,
    required this.sessions,
    required this.setState,
  }) : super(key: key);

  @override
  State<SessionAlertDialog> createState() => _SessionAlertDialogState();
}

class _SessionAlertDialogState extends State<SessionAlertDialog> {
  @override
  Widget build(BuildContext context) {
    DateFormat formater = DateFormat('EEE, dd MMM yyyy HH:mm:ss zzz');
    late bool iscurrentSession = widget.index == 0;
    DateTime date = formater.parse(widget.sessions[widget.index]['date_time']);
    int day = date.day;
    String monthName = DateFormat('MMMM', 'pt_BR').format(date);

    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              widget.isAndroid
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(widget.androidImage),
                      backgroundColor: Colors.transparent,
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(widget.iOSImage),
                      backgroundColor: Colors.transparent,
                    ),
              widget.isAndroid
                  ? const Text(
                      'Dispositivo Android',
                      style: TextStyle(fontSize: 20),
                    )
                  : const Text(
                      'Dispositivo IOS',
                      style: TextStyle(fontSize: 20),
                    ),
            ],
          )
        ],
      ),
      content: SizedBox(
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Nome do Dispositivo: ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(widget.sessions[widget.index]['device']),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Endereço IP: ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(widget.sessions[widget.index]['ip_address']),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Data de Início: ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text('$day de $monthName'),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Localização: ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(widget.sessions[widget.index]['location']),
              ],
            ),
          ],
        ),
      ),
      actions: [
        iscurrentSession
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButtomEndSession(
                    sessionId: widget.sessions[widget.index]['session_id'],
                    setState: widget.setState,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              )
      ],
    );
  }
}

class IconButtomEndSession extends StatefulWidget {
  final int sessionId;
  final void Function() setState;
  const IconButtomEndSession({Key? key, required this.sessionId, required this.setState}) : super(key: key);

  @override
  State<IconButtomEndSession> createState() => _IconButtomEndSessionState();
}

class _IconButtomEndSessionState extends State<IconButtomEndSession> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          _isLoading = true;
          updateSession(widget.sessionId).then((success) => {
                if (success)
                  {
                    setState(() {
                      _isLoading = false;
                    }),
                    Navigator.of(context).pop(),
                    widget.setState(),
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Sessão terminada com sucesso',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    ),
                  }
                else
                  {
                    setState(() {
                      _isLoading = false;
                    }),
                    Navigator.of(context).pop(),
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Não foi possível terminar a sessão',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    ),
                  }
              });
        });
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text(
              'Terminar Sessão',
              style: TextStyle(color: Colors.white),
            ),
    );
  }
}
