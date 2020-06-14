import 'package:equatable/equatable.dart';
import 'package:flutterApp/models/models.dart';
import 'package:meta/meta.dart';

abstract class AuthEvent extends Equatable {

  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthEventAppStart extends AuthEvent {

  @override
  String toString() {
    return 'AuthEventAppStart {}';
  }
}

class AuthEventSendCode extends AuthEvent {

  final String phoneNumber;

  AuthEventSendCode({@required this.phoneNumber});

  @override
  String toString() {
    return 'AuthEventSendCode { phoneNumber: $phoneNumber}';
  }
}

class AuthEventResendCode extends AuthEvent {

  @override
  String toString() {
    return 'AuthEventResendCode {}';
  }
}

class AuthEventValidatePhoneNumber extends AuthEvent {

  final String smsCode;

  AuthEventValidatePhoneNumber({@required this.smsCode});

  @override
  String toString() {
    return 'AuthEventValidatePhoneNumber { smsCode: $smsCode}';
  }
}

class AuthEventLogout extends AuthEvent {

  @override
  String toString() {
    return 'AuthEventLogout {}';
  }
}