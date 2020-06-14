import 'package:equatable/equatable.dart';
import 'package:flutterApp/models/models.dart';
import 'package:meta/meta.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthStateUninitialized extends AuthState {
  @override
  String toString() {
    return 'AuthStateUinitialized {}';
  }
}

class AuthStateAuthenticated extends AuthState {
  final User user;

  AuthStateAuthenticated({@required this.user});

  @override
  String toString() {
    return 'AuthStateAuthenticated {userId: ${user.userId}, userName: ${user.userName}, phoneNumber: ${user.phoneNumber}';
  }
}

class AuthStateUnauthenticated extends AuthState {
  @override
  String toString() {
    return 'AuthStateUnauthenticated {}';
  }
}

class AuthStateCodeSent extends AuthState {
  final String phoneNumber;

  AuthStateCodeSent({@required this.phoneNumber});

  @override
  String toString() {
    return 'AuthStateCodeSent { phoneNumber: $phoneNumber}';
  }
}