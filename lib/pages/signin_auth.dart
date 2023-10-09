import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:hima_front_end/pages/nonotification-Screen.dart';
import 'package:hima_front_end/pages/supervisor-home.dart';

class SignIn extends StatefulWidget {
  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.70,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(12),
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
                          'assets/images/Hima_logo.png',
                          height: 75,
                          width: 84,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //emailfield
                        emailField(),
                        const SizedBox(
                          height: 20,
                        ),
                        //passwordfield
                        passwordField(),
                        const SizedBox(
                          height: 20,
                        ),
                        //appear when the user not match
                        Text(
                          errMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFFF3D758)),
                        ),
                        //button
                        submitButton(),
                        const SizedBox(
                          height: 10,
                        ),
                        Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: visible,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            )),
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
              builder: (context) => const noNotificationScreen(),
            ),
          );
        }
      } else {
        errMessage = "البريد الالكتروني أو كلمة السر غير صحيحة";
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
          errMessage = "البريد الالكتروني أو كلمة المرور غير صحيحة";
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          errMessage = "البريد الالكتروني أو كلمة السر غير صحيحة";
          print('Wrong password provided for that user.');
        }
      }
    }
  }

  Widget emailField() {
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(8.0),
      /*decoration: BoxDecoration(
          border:
              Border.all(color: Color.fromARGB(255, 99, 154, 125), width: 4.0),
          borderRadius: BorderRadius.all(
              Radius.circular(5.0)
              ),
        ),*/
      color: Colors.white,
      width: 239.0,
      height: 47.0,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          decoration: const InputDecoration(
            hintTextDirection: TextDirection.rtl,
            icon: Icon(Icons.person, color: Color.fromARGB(255, 99, 154, 125)),
            labelText: (' البريد الالكتروني'),
            labelStyle: TextStyle(
              fontSize: 15,
            ),
          ),
          validator: (value) {
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
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(8.0),
      /*decoration: BoxDecoration(
          border:
              Border.all(color: Color.fromARGB(255, 99, 154, 125), width: 4.0),
          borderRadius: BorderRadius.all(
              Radius.circular(5.0)
              ),
        ),*/
      color: Colors.white,
      width: 239.0,
      height: 47.0,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          controller: passwordController,
          obscureText: _isObscure3,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintTextDirection: TextDirection.rtl,
            suffixIcon: IconButton(
                icon:
                    Icon(_isObscure3 ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _isObscure3 = !_isObscure3;
                  });
                }),
            icon: const Icon(
              Icons.lock,
              color: Color.fromARGB(255, 99, 154, 125),
            ),
            labelText: 'كلمة المرور',
            hintText: 'كلمة المرور',
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          validator: (value) {
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
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      elevation: 5.0,
      height: 40,
      onPressed: () {
        setState(() {
          visible = true;
        });
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
