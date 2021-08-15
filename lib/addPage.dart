// imports
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fast_color_picker/fast_color_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habitize/main.dart';

FirebaseFirestore fireDb = FirebaseFirestore.instance;

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  // Boiler plate code for pushing flutter local notifications
  late FlutterLocalNotificationsPlugin localNotification;
  void initState() {
    super.initState();
    var androidInit = new AndroidInitializationSettings('ic_launcher');
    var initSetting = InitializationSettings(android: androidInit);
    localNotification = new FlutterLocalNotificationsPlugin();
    localNotification.initialize(initSetting);
  }
  

  late String notify1;
  late String? notify2 = "0";
  late String? notify3 = "0";
  final TextEditingController targetController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  String targetType = "Days";
  late String themeColor;
  

  void setTargetTpye(String text) {
    setState(() {
      targetType = text;
    });
  }

  void setNotify1(String text) {
    setState(() {
      notify1 = text;
    });
  }

  void setNotify2(String text) {
    setState(() {
      notify2 = text;
    });
  }

  void setNotify3(String text) {
    setState(() {
      notify3 = text;
    });
  }

  void setThemeColor(String color) {
    setState(() {
      themeColor = color;
    });
  }

  void save() {

    // //For debugging purposes 
    // print(titleController.text);
    // print(targetController.text);
    // print(targetType);
    // print(notify1);
    // print(notify2);
    // print(notify3);
    // print(themeColor);

    // Storing the data from app to firebase firestore in the id of the user's email
    CollectionReference users = fireDb.collection(user!.email ?? "TRASH");
    users.add({
      'title': titleController.text,
      'target': targetController.text,
      'target_type': targetType,
      'notify1': notify1,
      'notify2': notify2,
      'notify3': notify3,
      'themeColor': themeColor
    }).then((value) {
      print(value);
      print('Habit has been added');
      Navigator.pushNamed(context, '/home');
    }).catchError((error) {
      print(error.message);
    });

  }

  @override
  Widget build(BuildContext context) {

    // Scaffold
    return Scaffold(
      backgroundColor: Colors.grey[100],

      // Appbar
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(
          "Habitize",
          style: GoogleFonts.firaSansCondensed(
              fontWeight: FontWeight.w900, letterSpacing: 1.0),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () => Navigator.pushNamed(context, '/home'),
              icon: Icon(Icons.close_rounded)),
        ],
      ),

      //Floating Action button
      floatingActionButton: FloatingActionButton(
        onPressed: save,
        child: Icon(Icons.add_rounded),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,

      // Main Body
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              controller: titleController,
              style: GoogleFonts.firaSansCondensed(fontWeight: FontWeight.w500),
              autofocus: false,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Titlecannot be empty";
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Enter the habit title",
                labelText: "Habit title",
                hintStyle:
                    GoogleFonts.firaSansCondensed(fontWeight: FontWeight.w500),
                labelStyle: GoogleFonts.firaSansCondensed(
                    fontWeight: FontWeight.w500,
                    color: Colors.deepPurpleAccent),
                errorStyle:
                    GoogleFonts.firaSansCondensed(fontWeight: FontWeight.w500),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        BorderSide(color: Colors.deepPurpleAccent, width: 2.0)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        BorderSide(color: Colors.deepPurpleAccent, width: 2.0)),
                prefixIcon:
                    Icon(Icons.title_rounded, color: Colors.deepPurpleAccent),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        BorderSide(color: Colors.redAccent, width: 2.0)),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TargetField(
              targetController: targetController,
              setTargetType: setTargetTpye,
            ),
            SizedBox(
              height: 16,
            ),
            Notify(
              setNotify1: setNotify1,
              setNotify2: setNotify2,
              setNotify3: setNotify3,
            ),
            SizedBox(
              height: 16,
            ),
            ThemeChooser(
              setThemeColor: setThemeColor,
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeChooser extends StatefulWidget {
  const ThemeChooser({Key? key, required this.setThemeColor}) : super(key: key);

  final ValueChanged<String> setThemeColor;

  @override
  _ThemeChooserState createState() => _ThemeChooserState();
}

class _ThemeChooserState extends State<ThemeChooser> {
  late Color _color = Colors.deepPurpleAccent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Theme Color",
          style: GoogleFonts.firaSansCondensed(fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 8,
        ),
        FastColorPicker(
          selectedColor: _color,
          onColorSelected: (color) {
            setState(() {
              _color = color;
              String c = color.toString().replaceRange(0, 10, "");
              c = c.substring(0, c.length - 1);
              print(c);
              widget.setThemeColor(c);
            });
          },
        ),
      ],
    );
  }
}

class Notify extends StatefulWidget {
  const Notify({
    Key? key,
    required this.setNotify1,
    required this.setNotify2,
    required this.setNotify3,
  }) : super(key: key);

  final ValueChanged<String> setNotify1;
  final ValueChanged<String> setNotify2;
  final ValueChanged<String> setNotify3;

  @override
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  bool notify2Visible = false;
  bool notify3Visible = false;
  String? timeSelected1;
  String? timeSelected2;
  String? timeSelected3;

  Future<void> selectTime(BuildContext context) async {
    var picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        int hour = picked.hour;
        if (picked.hour > 12) {
          hour = picked.hour - 12;
        }
        timeSelected1 = hour.toString() +
            " : " +
            picked.minute.toString() +
            picked.period.toString().replaceRange(0, 10, " ").toUpperCase();
        widget.setNotify1(timeSelected1!);
      });
    } else {
      setState(() {
        int hour = TimeOfDay.now().hour;
        if (TimeOfDay.now().hour > 12) {
          hour = TimeOfDay.now().hour - 12;
        }
        timeSelected1 = hour.toString() +
            " : " +
            TimeOfDay.now().hour.toString() +
            TimeOfDay.now()
                .period
                .toString()
                .replaceRange(0, 10, " ")
                .toUpperCase();
        widget.setNotify1(timeSelected1!);
      });
    }
  }

  Future<void> selectTime2(BuildContext context) async {
    var picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        int hour = picked.hour;
        if (picked.hour > 12) {
          hour = picked.hour - 12;
        }
        timeSelected2 = hour.toString() +
            " : " +
            picked.minute.toString() +
            picked.period.toString().replaceRange(0, 10, " ").toUpperCase();
        widget.setNotify2(timeSelected2!);
      });
    } else {
      setState(() {
        int hour = TimeOfDay.now().hour;
        if (TimeOfDay.now().hour > 12) {
          hour = TimeOfDay.now().hour - 12;
        }
        timeSelected2 = hour.toString() +
            " : " +
            TimeOfDay.now().hour.toString() +
            TimeOfDay.now()
                .period
                .toString()
                .replaceRange(0, 10, " ")
                .toUpperCase();
        widget.setNotify2(timeSelected2!);
      });
    }
  }

  Future<void> selectTime3(BuildContext context) async {
    var picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        int hour = picked.hour;
        if (picked.hour > 12) {
          hour = picked.hour - 12;
        }
        timeSelected3 = hour.toString() +
            " : " +
            picked.minute.toString() +
            picked.period.toString().replaceRange(0, 10, " ").toUpperCase();
        widget.setNotify3(timeSelected3!);
      });
    } else {
      setState(() {
        int hour = TimeOfDay.now().hour;
        if (TimeOfDay.now().hour > 12) {
          hour = TimeOfDay.now().hour - 12;
        }
        timeSelected3 = hour.toString() +
            " : " +
            TimeOfDay.now().hour.toString() +
            TimeOfDay.now()
                .period
                .toString()
                .replaceRange(0, 10, " ")
                .toUpperCase();
        widget.setNotify3(timeSelected3!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Notifications",
          style: GoogleFonts.firaSansCondensed(fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(primary: Colors.deepPurpleAccent),
                onPressed: () {
                  selectTime(context);
                },
                child: Text(
                  timeSelected1 ?? "select time",
                  style: GoogleFonts.firaSansCondensed(
                    fontWeight: FontWeight.w500,
                  ),
                )),
            SizedBox(
              width: 8,
            ),
            Visibility(
              visible: notify2Visible,
              child: Row(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurpleAccent),
                      onPressed: () {
                        selectTime2(context);
                      },
                      child: Text(
                        timeSelected2 ?? "select time",
                        style: GoogleFonts.firaSansCondensed(
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: notify3Visible,
              child: Row(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurpleAccent),
                      onPressed: () {
                        selectTime3(context);
                      },
                      child: Text(
                        timeSelected3 ?? "select time",
                        style: GoogleFonts.firaSansCondensed(
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (notify2Visible == true) {
                    notify3Visible = true;
                  }
                  notify2Visible = true;
                });
              },
              child: Icon(
                Icons.add_rounded,
                color: Colors.deepPurpleAccent,
              ),
            )
          ],
        )
      ],
    );
  }
}

class TargetField extends StatelessWidget {
  const TargetField({
    Key? key,
    required this.targetController,
    required this.setTargetType,
  }) : super(key: key);

  final ValueChanged<String> setTargetType;
  final TextEditingController targetController;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Flexible(
              child: TextFormField(
            controller: targetController,
            style: GoogleFonts.firaSansCondensed(fontWeight: FontWeight.w500),
            validator: (String? value) {
              if (value!.isEmpty) {
                return "Target cannot be empty";
              }
              return null;
            },
            autofocus: false,
            cursorColor: Colors.deepPurpleAccent,
            decoration: InputDecoration(
              hintText: "Enter your target",
              labelText: "Target",
              hintStyle:
                  GoogleFonts.firaSansCondensed(fontWeight: FontWeight.w500),
              labelStyle: GoogleFonts.firaSansCondensed(
                  fontWeight: FontWeight.w500, color: Colors.deepPurpleAccent),
              errorStyle:
                  GoogleFonts.firaSansCondensed(fontWeight: FontWeight.w500),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:
                      BorderSide(color: Colors.deepPurpleAccent, width: 2.0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:
                      BorderSide(color: Colors.deepPurpleAccent, width: 2.0)),
              prefixIcon:
                  Icon(Icons.whatshot_rounded, color: Colors.deepPurpleAccent),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.redAccent, width: 2.0)),
            ),
          )),
          SizedBox(
            width: 16,
          ),
          Flexible(
            child: DropdownButtonFormField<String>(
              value: "Days",
              focusColor: Colors.deepPurpleAccent,
              decoration: InputDecoration(
                labelText: "Target type",
                hintStyle:
                    GoogleFonts.firaSansCondensed(fontWeight: FontWeight.w500),
                labelStyle: GoogleFonts.firaSansCondensed(
                    fontWeight: FontWeight.w500,
                    color: Colors.deepPurpleAccent),
                errorStyle:
                    GoogleFonts.firaSansCondensed(fontWeight: FontWeight.w500),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        BorderSide(color: Colors.deepPurpleAccent, width: 2.0)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        BorderSide(color: Colors.deepPurpleAccent, width: 2.0)),
                prefixIcon: Icon(Icons.whatshot_rounded,
                    color: Colors.deepPurpleAccent),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        BorderSide(color: Colors.redAccent, width: 2.0)),
              ),
              style: GoogleFonts.firaSansCondensed(
                  fontWeight: FontWeight.w500, color: Colors.black),
              items: [
                DropdownMenuItem<String>(
                  value: "Days",
                  child: new Text("Days"),
                ),
                DropdownMenuItem<String>(
                  value: "Weeks",
                  child: new Text("Weeks"),
                ),
                DropdownMenuItem<String>(
                  value: "Moths",
                  child: new Text("Months"),
                ),
                DropdownMenuItem<String>(
                  value: "Years",
                  child: new Text("Years"),
                ),
              ],
              onChanged: (value) {
                setTargetType(value!);
              },
              onSaved: (value) {
                setTargetType(value!);
              },
            ),
          )
        ],
      ),
    );
  }
}

class Notification extends StatefulWidget {
  const Notification({Key? key}) : super(key: key);

  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
