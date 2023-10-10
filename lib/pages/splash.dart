//import flutter material
import 'package:flutter/material.dart';

//import signin.dart to show after splash screen
import 'signin_auth.dart';

//statefullwidget to create state
class Splash extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}

//class to handle the state
class SplashState extends State<Splash> {
  //initstate to start right when invoking the class
  @override
  void initState() {
    super.initState();
    //handling time and go to the sign in screen
    _navigatetohome();
  }

  //method to handle the duration and if finished go to sign in screen
  _navigatetohome() async {
    await Future.delayed(const Duration(milliseconds: 1400), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignIn()));
  }

  //build the splash screen
  @override
  Widget build(context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(margin: const EdgeInsets.only(top: 180.0)),
            Image.asset(
              'assets/images/Hima_logo.jpg',
              height: 100,
              width: 113,
            ),
          ],
        ),
      ),
    );
  }
}
