import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hello_app/pages/api.dart';
import 'package:hello_app/pages/home.dart';
import 'package:hello_app/pages/login.dart';
import 'package:hello_app/pages/signup.dart';
import 'package:hello_app/pages/welcome.dart';
import 'package:hello_app/screens/splash_screen.dart';

import '../firebase_options.dart';

// function to trigger build when the app is run
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/splash': (context) => const SplashScreen(),
      '/': (context) => const WelcomeRoute(),
      '/registration': (context) => const SignupPage(),
      '/login': (context) => const LoginPage(),
      '/home': (context) => const UserProfile(),
      '/third': (context) => const ThirdRoute(),
    },
  ));
}
