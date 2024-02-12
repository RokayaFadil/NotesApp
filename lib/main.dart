import 'package:flutter/material.dart';
import 'package:notes_app/app/auth/login.dart';
import 'package:notes_app/app/auth/singup.dart';
import 'package:notes_app/app/home.dart';
import 'package:notes_app/app/notes/add.dart';
import 'package:notes_app/app/notes/edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences SharedPref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPref = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      initialRoute: SharedPref.getString("id") == null ? "login" : "home",
      routes: {
        "login": (context) => const Login(),
        "singup": (context) => const SingUp(),
        "home": (context) => const Home(),
        "addnotes": (context) => const AddNotes(),
        "editnotes": (context) => const EditNotes()
      },
    );
  }
}
