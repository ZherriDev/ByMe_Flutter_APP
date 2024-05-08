import 'package:flutter/material.dart';
import 'package:byme_flutter_app/utils/fetch_user_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: fetchUserData(context),
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
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width / 2 + 160,
                height: 200,
                decoration: BoxDecoration(
                    color: Color(0xFF787878).withOpacity(0.16),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xff672D6F),
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        snapshot.data?['doctor']['fullname'],
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        snapshot.data?['doctor']['fullname'],
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
