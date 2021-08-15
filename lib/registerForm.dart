import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class RegisterForm extends StatefulWidget {
  RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final double _space = 16;
  String _text = "";
  bool _visibleState = false;

  void updateError(String text) {
    setState(() {
      _text = text;
      _visibleState = true;
    });
  }

  @override
  void dispose() {
    
    emailController.dispose();
    passwordController.dispose();
    fullnameController.dispose();
    super.dispose();
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
        actions: <Widget>[
          IconButton(
              onPressed: () {
                print("add Clicked");
              },
              icon: Icon(Icons.add_rounded)),
        ],
        leading: IconButton(
            onPressed: () => print("Setting clicked"),
            icon: Icon(Icons.settings_rounded)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:Form(
          key: _formKey,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign Up",
                  style: GoogleFonts.firaSansCondensed(
                    fontWeight: FontWeight.w800,
                    fontSize: 52,
                  ),
                ),
                SizedBox(height: _space + 10),
                FullName(fullnameController: fullnameController),
                SizedBox(height: _space),
                Email(emailController: emailController),
                SizedBox(height: _space),
                Container(
                  child: Password(passwordController: passwordController),
                  margin: EdgeInsets.only(bottom: 8.0),
                ),
                Visibility(
                  child: Container(
                    margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Flexible(
                          child: Text(
                            _text,
                            style: GoogleFonts.firaSansCondensed(
                                fontWeight: FontWeight.w500,
                                color: Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                  visible: _visibleState,
                ),
                Container(
                  margin: EdgeInsets.only(top: 8.0),
                  child: SignIn_Button(
                    emailController: emailController,
                    passwordController: passwordController,
                    fullnameController: fullnameController,
                    space: _space,
                    updateError: updateError,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class SignIn_Button extends StatelessWidget {
  final ValueChanged<String> updateError;
  const SignIn_Button({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.fullnameController,
    required this.updateError,
    required double space,
  })  : _space = space,
        super(key: key);

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController fullnameController;

  final double _space;

  Future<User?> _register() async {
    final User? _user = (await _auth.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ))
        .user;

    _user!.updateDisplayName(fullnameController.text);

    
    if (_user != null) {
      return _user;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _register().then((_user) {
            Hive.box('user').put("isUserCreated", "true");
            Navigator.pushNamed(context, '/home');
          }).catchError((e) {
            print(e.message);
            updateError(e.message);
          });
        }
      },
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign Up",
              style: GoogleFonts.firaSansCondensed(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(
              width: _space,
            ),
            Icon(Icons.arrow_forward_rounded)
          ],
        ),
      ),
    );
  }
}

class Password extends StatelessWidget {
  const Password({
    Key? key,
    required this.passwordController,
  }) : super(key: key);

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: GoogleFonts.firaSansCondensed(fontWeight: FontWeight.w500),
      controller: passwordController,
      textInputAction: TextInputAction.next,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: "Enter your password",
          labelText: "Password",
          hintStyle: GoogleFonts.firaSansCondensed(fontWeight: FontWeight.w500),
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
          ),
          prefixIcon: Icon(
            Icons.lock_rounded,
            color: Colors.deepPurpleAccent,
          )),
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
    );
  }
}

class Email extends StatelessWidget {
  const Email({
    Key? key,
    required this.emailController,
  }) : super(key: key);

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: GoogleFonts.firaSansCondensed(fontWeight: FontWeight.w500),
      controller: emailController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Email cannot be empty";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Enter your email",
        labelText: "Email",
        hintStyle: GoogleFonts.firaSansCondensed(fontWeight: FontWeight.w500),
        labelStyle: GoogleFonts.firaSansCondensed(
            fontWeight: FontWeight.w500, color: Colors.deepPurpleAccent),
        errorStyle: GoogleFonts.firaSansCondensed(fontWeight: FontWeight.w500),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2.0)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2.0)),
        prefixIcon:
            Icon(Icons.account_circle_rounded, color: Colors.deepPurpleAccent),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.redAccent, width: 2.0)),
      ),
    );
  }
}

class FullName extends StatelessWidget {
  const FullName({
    Key? key,
    required this.fullnameController,
  }) : super(key: key);

  final fullnameController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: GoogleFonts.firaSansCondensed(fontWeight: FontWeight.w500),
      controller: fullnameController,
      textInputAction: TextInputAction.next,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Full name Cannot be empty";
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: "Enter your name",
          labelText: "Full name",
          hintStyle: GoogleFonts.firaSansCondensed(fontWeight: FontWeight.w500),
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
          ),
          prefixIcon: Icon(
            Icons.badge_rounded,
            color: Colors.deepPurpleAccent,
          )),
    );
  }
}
