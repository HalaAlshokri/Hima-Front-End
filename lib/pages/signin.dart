//import flutter material
import 'package:flutter/material.dart';

//import bloc.dart to manage validation
import 'blocs/bloc.dart';

//Sign in implementation with build, nameField, passField, and submitButton methods
class SignIn extends StatelessWidget {
  @override
  Widget build(context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        padding: const EdgeInsets.all(35),
        alignment: Alignment.center,
        child: Column(
          children: [
            //start space about 40 from top
            Container(margin: const EdgeInsets.only(top: 40.0)),
            //hima logo
            Image.asset(
              'assets/hima_logo.jpeg',
              height: 170,
              width: 170,
            ),
            //space between logo and name field
            Container(margin: const EdgeInsets.only(top: 30.0)),
            nameField(),
            passField(),
            //space between password field and submit button
            Container(margin: const EdgeInsets.only(top: 45.0)),
            submitButton(),
          ],
        ),
      ),
    );
  }

  //method to handle name Field
  Widget nameField() {
    return StreamBuilder(
        stream: bloc.name,
        builder: (context, snapshot) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              onChanged: bloc.changeName,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                icon: const Icon(Icons.person),
                labelText: ('اسم المستخدم'),
                hintText: 'اسم المستخدم',
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                errorText: snapshot.error as dynamic,
              ),
            ),
          );
        });
  }

  //method to handle password field
  Widget passField() {
    return StreamBuilder(
      stream: bloc.password,
      builder: (context, snapshot) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: TextFormField(
            onChanged: bloc.changePassword,
            obscureText: true,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              icon: const Icon(Icons.lock),
              labelText: 'الرقم السري',
              hintText: 'الرقم السري',
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              errorText: snapshot.error as dynamic,
            ),
          ),
        );
      },
    );
  }

  //method to handle submit button
  Widget submitButton() {
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return FilledButton(
          onPressed: snapshot.hasData ? bloc.submit : null,
          child: const Text(
              '                     تسجيل الدخول                     '),
        );
      },
    );
  }
}
