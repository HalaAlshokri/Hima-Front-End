//import flutter material
import 'package:flutter/material.dart';

//import signin.dart to show after splash screen
import 'signin.dart';

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
    //handling to show the sign in screen
    _navigatetohome();
  }

  //method to handle if the duration finished show sign in screen
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
        color: const Color.fromARGB(255, 8, 107, 86),
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(margin: const EdgeInsets.only(top: 130.0)),
            Image.asset(
              'assets/images/Hima_logo.png',
              height: 180,
              width: 180,
            ),
          ],
        ),
      ),
    );
  }
}

////---------------------------main-----------------------
void main() {
  runApp(App());
}

//App class override build method to implement splash
class App extends StatelessWidget {
  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        body: Splash(),
      ),
      title: 'sign in screen',
      theme: ThemeData(
        useMaterial3: true,
        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 8, 107, 86),
          brightness: Brightness.light,
        ),
        // Define the default `TextTheme`.
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
