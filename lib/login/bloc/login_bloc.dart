import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterApp/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:flutterApp/login/login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is VerifyPhonePressed) {
      yield* _mapVerifyPhonePressedToState(event.phoneNumber);
    } else if (event is ValidateOtpPressed) {
      yield* _mapValidateOtpPressedToState(event.smsCode);
    } else if (event is ResendCodePressed) {
      yield* _mapResendCodePressedToState();
    }
  }

  Stream<LoginState> _mapVerifyPhonePressedToState(String phoneNumber) async* {
    String actualCode;
    try {
      await _userRepository.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (AuthCredential auth) async {
            print('VerifivationCompleted { phoneNumber: $phoneNumber}');
          },
          verificationFailed: (AuthException authException) async {
            print('Error message: ' + authException.message);
          },
          codeSent: (String verificationId, [int forceResendingToken]) async {
            actualCode = verificationId;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            actualCode = verificationId;
          });
      yield LoginValidPhoneNumber(
        phoneNumber: phoneNumber,
        verificationId: actualCode,
      );
    } catch (_) {
      yield LoginInvalidPhoneNumber(phoneNumber: phoneNumber);
    }
  }

  Stream<LoginState> _mapValidateOtpPressedToState(String smsCode) async* {
    final currentState = state;

    if (currentState is LoginValidPhoneNumber) {
      try {
        await _userRepository.validateOtpAndLogin(
            currentState.verificationId, smsCode);
        yield LoginValidSMSCode(
          phoneNumber: currentState.phoneNumber,
          verificationId: currentState.verificationId,
        );
      } catch (_) {
        yield LoginInvalidSMSCode(
          phoneNumber: currentState.phoneNumber,
          verificationId: currentState.verificationId,
        );
      }
    } else if (currentState is LoginInvalidSMSCode) {
      try {
        await _userRepository.validateOtpAndLogin(
            currentState.verificationId, smsCode);
        yield LoginValidSMSCode(
          phoneNumber: currentState.phoneNumber,
          verificationId: currentState.verificationId,
        );
      } catch (_) {
        yield LoginInvalidSMSCode(
          phoneNumber: currentState.phoneNumber,
          verificationId: currentState.verificationId,
        );
      }
    }
  }

  Stream<LoginState> _mapResendCodePressedToState() async* {
    final currentState = state;

    if (currentState is LoginInvalidSMSCode) {
      try {
        String actualCode;
        await _userRepository.verifyPhoneNumber(
            phoneNumber: currentState.phoneNumber,
            timeout: const Duration(seconds: 60),
            verificationCompleted: (AuthCredential auth) async {
              print('VerifivationCompleted { phoneNumber: $currentState.phoneNumber}');
            },
            verificationFailed: (AuthException authException) async {
              throw new Exception('Error message: ' + authException.message);
            },
            codeSent: (String verificationId, [int forceResendingToken]) async {
              actualCode = verificationId;
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              actualCode = verificationId;
            });
        yield LoginValidPhoneNumber(
          phoneNumber: currentState.phoneNumber,
          verificationId: actualCode,
        );
      } catch (_) {
        yield LoginInvalidPhoneNumber(phoneNumber: currentState.phoneNumber);
      }
    }
  }
}
