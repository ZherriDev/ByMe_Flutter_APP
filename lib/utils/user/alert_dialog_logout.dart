import "package:byme_flutter_app/utils/token/logout.dart";
import "package:flutter/material.dart";

class AlertDialogLogout extends StatefulWidget {
  @override
  State<AlertDialogLogout> createState() => _AlertDialogLogoutState();
}

class _AlertDialogLogoutState extends State<AlertDialogLogout> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: SizedBox(
        width: 150,
        height: 150,
        child: Image.asset('assets/images/warning.png'),
      ),
      content: Text(
        'Tens a certeza que queres terminar sessão?',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                });
                LogOut().then((success) => {
                      if (success)
                        {
                          setState(() {
                            _isLoading = false;
                          }),
                          Navigator.of(context).pushNamed('/'),
                        }
                      else
                        {
                          setState(() {
                            _isLoading = false;
                          }),
                          Navigator.of(context).pop(),
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
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
              },
              child: _isLoading
                  ? CircularProgressIndicator()
                  : const Text(
                      'Terminar Sessão',
                      style: TextStyle(color: Colors.white),
                    ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        )
      ],
    );
  }
}
