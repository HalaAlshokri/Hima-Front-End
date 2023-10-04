import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:hima_front_end/pages/nonotification-Screen.dart';
import 'package:hima_front_end/pages/supervisor-home.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  String ErrMessage = "";

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
                  margin: EdgeInsets.all(12),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        //hima logo
                        Image.asset(
                          'assets/images/Hima_logo.png',
                          height: 170,
                          width: 170,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //emailfield
                        emailField(),
                        SizedBox(
                          height: 20,
                        ),
                        //passwordfield
                        passwordField(),
                        SizedBox(
                          height: 20,
                        ),
                        //appear when the user not match
                        Text(
                          ErrMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.yellow),
                        ),
                        //button
                        submitButton(),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: visible,
                            child: Container(
                                child: CircularProgressIndicator(
                              color: Colors.white,
                            ))),
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
    var kk = FirebaseFirestore.instance
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
        ErrMessage = "البريد الالكتروني أو كلمة السر غير صحيحة";
        print('Document does not exist on the database');
      }
    });
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        route();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ErrMessage = "البريد الالكتروني أو كلمة السر غير صحيحة";
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          ErrMessage = "البريد الالكتروني أو كلمة السر غير صحيحة";
          print('Wrong password provided for that user.');
        }
      }
    }
  }

  Widget emailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintTextDirection: TextDirection.rtl,
        icon: const Icon(Icons.person),
        labelText: ('اسم المستخدم'),
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      validator: (value) {
        if (value!.length == 0) {
          return "يجب تعبئة البريد الالكتروني";
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("الرجاء ادخال بريد الكتروني صالح");
        } else {
          return null;
        }
      },
      onSaved: (value) {
        emailController.text = value!;
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: _isObscure3,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintTextDirection: TextDirection.rtl,
        suffixIcon: IconButton(
            icon: Icon(_isObscure3 ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isObscure3 = !_isObscure3;
              });
            }),
        icon: const Icon(Icons.lock),
        labelText: 'الرقم السري',
        hintText: 'الرقم السري',
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      validator: (value) {
        RegExp regex = new RegExp(r'^.{5,}$');
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
    );
  }

  Widget submitButton() {
    return MaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      elevation: 5.0,
      height: 40,
      onPressed: () {
        setState(() {
          visible = true;
        });
        signIn(emailController.text, passwordController.text);
      },
      child: Text(
        "    تسجيل الدخول     ",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      color: Color.fromARGB(255, 99, 154, 125),
    );
  }
}
