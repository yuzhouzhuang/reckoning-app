import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}


class LoginInitial extends LoginState {}

class LoginInvalidPhoneNumber extends LoginState {
  final String phoneNumber;

  const LoginInvalidPhoneNumber({@required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];

  @override
  String toString() {
    return 'InvalidPhoneNumber { phoneNumber: $phoneNumber }';
  }
}

class LoginValidPhoneNumber extends LoginState {
  final String phoneNumber;
  final String verificationId;

  const LoginValidPhoneNumber({@required this.phoneNumber, @required this.verificationId});

  @override
  List<Object> get props => [phoneNumber, verificationId];

  @override
  String toString() {
    return 'ValidPhoneNumber { phoneNumber: $phoneNumber, verificationId: $verificationId }';
  }
}

class LoginInvalidSMSCode extends LoginState {
  final String phoneNumber;
  final String verificationId;

  const LoginInvalidSMSCode({@required this.phoneNumber, @required this.verificationId});

  @override
  List<Object> get props => [phoneNumber, verificationId];

  @override
  String toString() {
    return 'InValidSMSCode { phoneNumber: $phoneNumber, verificationId: $verificationId }';
  }
}

class LoginValidSMSCode extends LoginState {
  final String phoneNumber;
  final String verificationId;

  const LoginValidSMSCode({@required this.phoneNumber, @required this.verificationId});

  @override
  List<Object> get props => [phoneNumber, verificationId];

  @override
  String toString() {
    return 'ValidSMSCode { phoneNumber: $phoneNumber, verificationId: $verificationId }';
  }
}
