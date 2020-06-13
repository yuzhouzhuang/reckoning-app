import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class VerifyPhonePressed extends LoginEvent {
  final String phoneNumber;

  const VerifyPhonePressed({@required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];

  @override
  String toString() {
    return 'VerifyPhonePressed { phoneNumber: $phoneNumber }';
  }
}

class ResendCodePressed extends LoginEvent {}

class ValidateOtpPressed extends LoginEvent {
  final String smsCode;

  const ValidateOtpPressed(
      {@required this.smsCode});

  @override
  List<Object> get props => [smsCode];

  @override
  String toString() {
    return 'ValidateOtpPressed { smsCode: $smsCode }';
  }
}
