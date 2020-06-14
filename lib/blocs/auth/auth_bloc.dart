import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutterApp/models/models.dart';
import 'package:flutterApp/user_repository.dart';
import 'package:meta/meta.dart';
import './bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  @override
  AuthState get initialState => AuthStateUninitialized();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthEventAppStart) {
      yield* _mapAppStartToState();
    } else if (event is AuthEventSendCode) {
      yield* _mapSendCodeToState(event);
    } else if (event is AuthEventResendCode) {
      yield* _mapResendCodeToState();
    } else if (event is AuthEventValidatePhoneNumber) {
      yield* _mapValidatePhoneNumberToState(event);
    } else if (event is AuthEventLogout) {
      yield* _mapLogoutToState();
    }
  }

  Stream<AuthState> _mapAppStartToState() async* {
    try {
      final isAuthenticated = await UserRepository().isAuthenticated();
      if (isAuthenticated) {
        yield AuthStateAuthenticated(user: await UserRepository().getUser());
      } else {
        yield AuthStateUnauthenticated();
      }
    } catch (_) {
      yield AuthStateUnauthenticated();
    }
  }

  Stream<AuthState> _mapSendCodeToState(AuthEvent event) async* {
    await UserRepository()
        .verifyPhoneNumber((event as AuthEventSendCode).phoneNumber);
    yield AuthStateCodeSent(
        phoneNumber: (event as AuthEventSendCode).phoneNumber);
  }

  Stream<AuthState> _mapResendCodeToState() async* {
    await UserRepository()
        .verifyPhoneNumber((state as AuthStateCodeSent).phoneNumber);
    yield AuthStateCodeSent(
        phoneNumber: ((state as AuthStateCodeSent).phoneNumber));
  }

  Stream<AuthState> _mapValidatePhoneNumberToState(AuthEvent event) async* {
    User _user = await UserRepository()
        .validateOtpAndLogin((event as AuthEventValidatePhoneNumber).smsCode);
    yield AuthStateAuthenticated(user: _user);
  }

  Stream<AuthState> _mapLogoutToState() async* {
    await UserRepository().signOut();
    yield AuthStateUnauthenticated();
  }
}
