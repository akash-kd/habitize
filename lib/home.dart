import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habitize/homeContainer.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

User? user = FirebaseAuth.instance.currentUser;

var userDB = Hive.box("user");

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> verifyEmail() async {
    print(user!.emailVerified);
    if (user != null && user!.emailVerified == false) {
      await user!.sendEmailVerification();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(
          "Habitize",
          style: GoogleFonts.firaSansCondensed(
              fontWeight: FontWeight.w900, letterSpacing: 1.0),
        ),
        automaticallyImplyLeading: false,

        //Add action button 
        // ^ onPressed => addHabit()



        actions: <Widget>[
          IconButton(
              onPressed: ()=>Navigator.pushNamed(context, '/addHabit'),
              icon: Icon(Icons.add_rounded)),
        ],
        leading: IconButton(
            onPressed: () => print("Setting clicked"),
            icon: Icon(Icons.settings_rounded)),
      ),
      body: Container(child: HomeContainer()),
    );
  }
}
