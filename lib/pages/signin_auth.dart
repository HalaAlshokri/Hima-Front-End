import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:hima_front_end/pages/officer.dart';
import 'package:hima_front_end/pages/supervisor-home.dart';

class SignIn extends StatefulWidget {
  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  bool _isObscure3 = true; //to show the password or not
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errMessage =
      ""; //error message will be shown if there is in submitting the entries

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(12.0, 140.0, 12.0, 12.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        //hima logo
                        Image.asset(
                          'assets/images/Hima_logo.jpg',
                          height: 200,
                          width: 200,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        //emailfield
                        emailField(),
                        const SizedBox(
                          height: 30,
                          width: 220,
                        ),
                        //passwordfield
                        passwordField(),
                        const SizedBox(
                          height: 20,
                          width: 220,
                        ),
                        //appear when the user not match
                        Text(
                          errMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFFF3D758),
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //button
                        submitButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        var sessionManager = SessionManager();
        await sessionManager.set("id", documentSnapshot.get('email'));
        await sessionManager.set("role", documentSnapshot.get('role'));
        if (documentSnapshot.get('role') == "supervisor") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SupervisorHomepage(),
            ),
          );
        } else if (documentSnapshot.get('role') == "officer") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const OfficerHomepage(),
            ),
          );
        }
      } else {
        errMessage = "البريد الالكتروني أو كلمة المرور خاطئة\nحاول مرة أخرى";
        print('Document does not exist on the database');
      }
    });
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        route();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          errMessage = "البريد الالكتروني أو كلمة المرور خاطئة\nحاول مرة أخرى";
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          errMessage = "البريد الالكتروني أو كلمة المرور خاطئة\nحاول مرة أخرى";
          print('Wrong password provided for that user.');
        }
      }
    }
  }

  Widget emailField() {
    return Container(
      margin: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 1.0),
      padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 1.0),
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color.fromARGB(255, 99, 154, 125), width: 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        color: Colors.white,
      ),
      width: 290.0,
      height: 50.0,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          textInputAction: TextInputAction.next,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            contentPadding:
                EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            //filled: true,
            border: InputBorder.none,
            icon: Icon(Icons.person, color: Color.fromARGB(255, 99, 154, 125)),
            hintText: (' البريد الالكتروني'),
            labelStyle: TextStyle(
              fontSize: 15,
            ),
          ),
          validator: (String? value) {
            if (value!.isEmpty) {
              return "يجب تعبئة البريد الالكتروني";
            }
            if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                .hasMatch(value)) {
              return ("الرجاء ادخال بريد الكتروني صالح");
            } else {
              return null;
            }
          },
          onSaved: (value) {
            emailController.text = value!;
          },
        ),
      ),
    );
  }

  Widget passwordField() {
    return Container(
      margin: const EdgeInsets.fromLTRB(4.0, 1.0, 4.0, 1.0),
      padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 1.0),
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color.fromARGB(255, 99, 154, 125), width: 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        color: Colors.white,
      ),
      width: 290.0,
      height: 50.0,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          controller: passwordController,
          obscureText: _isObscure3,
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: IconButton(
                icon: Icon(
                  _isObscure3 ? Icons.visibility : Icons.visibility_off,
                  color: Color.fromARGB(255, 99, 154, 125),
                ),
                onPressed: () {
                  setState(() {
                    _isObscure3 = !_isObscure3;
                  });
                }),
            icon: const Icon(
              Icons.lock,
              color: Color.fromARGB(255, 99, 154, 125),
            ),
            hintText: 'كلمة المرور',
            labelStyle: const TextStyle(
              fontSize: 15,
            ),
          ),
          validator: (String? value) {
            RegExp regex = RegExp(r'^.{5,}$');
            if (value!.isEmpty) {
              return "يجب تعبئة كلمة المرور";
            }
            if (!regex.hasMatch(value)) {
              return ("الرجاء ادخال اكثر من 5");
            } else {
              return null;
            }
          },
          onSaved: (value) {
            passwordController.text = value!;
          },
        ),
      ),
    );
  }

  Widget submitButton() {
    return MaterialButton(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      elevation: 5.0,
      height: 40,
      onPressed: () {
        signIn(emailController.text, passwordController.text);
      },
      color: const Color.fromARGB(255, 99, 154, 125),
      child: const Text(
        "    تسجيل الدخول     ",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
