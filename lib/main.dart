import 'package:byme_flutter_app/pages/auth/landing_page.dart';
import 'package:byme_flutter_app/pages/auth/register_page.dart';
import 'package:byme_flutter_app/pages/auth/login_page.dart';
import 'package:byme_flutter_app/pages/auth/forgot_pass_page.dart';
import 'package:byme_flutter_app/pages/navigation/inside_app.dart';
import 'package:byme_flutter_app/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('pt_BR', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, app) {
          if (app.connectionState == ConnectionState.done) {
            return ChangeNotifierProvider(
              create: (BuildContext context) => UIProvider()..init(),
              child: Consumer<UIProvider>(
                  builder: (context, UIProvider notifier, child) {
                return MaterialApp(
                  title: 'ByMe',
                  themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,
                  darkTheme: notifier.darkTheme,
                  theme: notifier.lightTheme,
                  initialRoute: '/',
                  routes: {
                    '/': (context) => const LandingPage(),
                    '/register': (context) => const RegisterPage(),
                    '/login': (context) => const LoginPage(),
                    '/forgot_password': (context) => const ForgotPasswordPage(),
                    '/inside_app': (context) => const InsideApp(),
                  },
                  debugShowCheckedModeBanner: false,
                );
              }),
            );
          }
          if (app.hasError) {
            return Text('Error');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
