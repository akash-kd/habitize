import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitize/addPage.dart';
import 'package:habitize/home.dart';
import 'package:habitize/loginForm.dart';
import 'package:habitize/registerForm.dart';


User? user = FirebaseAuth.instance.currentUser;

Widget isUserCreated() {
  if (user == null) {
    return LoginForm();
  } else {
    return Home();
  }
}

// ! Main function : the first function to run
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Hive initialization
  // await Hive.initFlutter();
  // await Hive.openBox('user');

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Habitize",
    initialRoute: '/',
    theme: ThemeData(
      accentColor: Colors.cyan[600],
      primaryColor: Colors.deepPurpleAccent,
    ),
    routes: {
      // * Redirects to Login Page
      '/': (context) => isUserCreated(),

      // * Redirects to home
      '/home': (context) => const Home(),

      // * Add Page
      '/addHabit': (context) => AddPage(),

      // * Redirects to Sign Up page
      '/register': (context) => RegisterForm(),
    },
  ));
}
