//import async library
import 'dart:async';

//import rxdart to handle submit
import 'package:rxdart/rxdart.dart';

//import validators.dart
import 'validators.dart';

//class to handle validators via Streams
class Bloc extends Validators {
  //blocs
  final _nameController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //add data to stream
  Stream<String> get name => _nameController.stream.transform(validateName);
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);

  Stream<bool> get submitValid =>
      Rx.combineLatest2(name, password, (n, p) => true);

  //change data
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  submit() {
    final validName = _nameController.value;
    final validPassword = _passwordController.value;
    //print submited value
    print('the name is $validName. and the password is $validPassword');
  }

  //close controller
  dispose() {
    _nameController.close();
    _passwordController.close();
  }
}

//creating bloc instance to use in signin directly
final bloc = Bloc();
