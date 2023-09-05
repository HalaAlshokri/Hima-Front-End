//import async library
import 'dart:async';

//create the conditions to validate the name, and password fields
class Validators {
  //validating name
  final validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length < 10) {
      sink.add(name);
    } else {
      sink.addError('Enter less than 10 characters');
    }
  });

  //validating password
  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 5) {
      sink.add(password);
    } else {
      sink.addError('Password must be at least 6 characters');
    }
  });
}
