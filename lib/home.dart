import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habitize/homeContainer.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      //! APP BAR
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

        //! ACTION BUTTONS
        // * the Widgets that come after the title with space in btw as expanded
        actions: <Widget>[
          IconButton(
              onPressed: () => Navigator.pushNamed(context, '/addHabit'),
              icon: Icon(Icons.add_rounded)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListUI(),
      ),
    );
  }
}

// !MAIN BODY OF HOME PAGE
// * This Widget retrieves the data from firebase firestore, Streambuild
// * uses the strem from firebase and convert that list of HabitWidget

class ListUI extends StatefulWidget {
  @override
  _ListUIState createState() => _ListUIState();
}

class _ListUIState extends State<ListUI> {
  final Stream<QuerySnapshot> data =
      FirebaseFirestore.instance.collection(user!.email ?? "TRASH").snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: data,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Column(children: [
                HabitWidget(
                  title: data['title'],
                  target: data['target'],
                  targetType: data['target_type'],
                  notify1: data['notify1'],
                  notify2: data['notify2'],
                  notify3: data['notify3'],
                  themeColor: data['themeColor'],
                )
              ]);
            }).toList(),
          );
        });
  }
}

class HabitWidget extends StatelessWidget {
  final String title;
  final String target;
  final String targetType;
  final String notify1;
  final String notify2;
  final String notify3;
  final String themeColor;

  const HabitWidget({
    Key? key,
    required this.title,
    required this.target,
    required this.targetType,
    required this.notify1,
    required this.notify2,
    required this.notify3,
    required this.themeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color thColor = HexColor('#' + themeColor);
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          border: Border.all(color: thColor, width: 2),
          borderRadius: BorderRadius.circular(8),
          color: thColor.withOpacity(0.25)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.firaSansCondensed(
                      fontSize: 28, fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    Text(target),
                    SizedBox(
                      width: 8,
                    ),
                    Text(targetType),
                  ],
                ),
                Row(
                  children: [
                    Text(notify1),
                  ],
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  print("Done For Today");
                },
                icon: Icon(Icons.done_rounded),
                color: thColor,
              ),
              IconButton(
                onPressed: () {
                  print("Done For Today");
                },
                icon: Icon(Icons.close_rounded),
                color: thColor,
              )
            ],
          ),
        ],
      ),
    );
  }
}
