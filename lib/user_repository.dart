
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterApp/models/user.dart';
import 'package:meta/meta.dart';

class UserRepository {

  static final UserRepository _instance = UserRepository._internal();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _verificationId;


  UserRepository._internal();

  factory UserRepository() {
    return _instance;
  }

  Future<void> signOut() async {
    return Future.wait([_firebaseAuth.signOut()]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }


  Future<void> verifyPhoneNumber(String phoneNumber) async {
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+44" + phoneNumber,
        timeout: Duration(seconds: 10),
        verificationCompleted: (authCredential) =>
            _verificationComplete(authCredential),
        verificationFailed: (authException) =>
            _verificationFailed(authException),
        codeSent: (verificationId, [code]) =>
            _smsCodeSent(verificationId, [code]),
        codeAutoRetrievalTimeout: (verificationId) =>
            _codeAutoRetrievalTimeout(verificationId));
  }

  Future<User> getUser() async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    return User.fromFirebaseUser(firebaseUser);
  }

  Future<bool> isAuthenticated() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  void _verificationComplete(AuthCredential authCredential) {}

  void _smsCodeSent(String verificationId, List<int> code) {
    this._verificationId = verificationId;
  }

  String _verificationFailed(AuthException authException) {
    return authException.message;
  }

  void _codeAutoRetrievalTimeout(String verificationId) {
    this._verificationId = verificationId;
  }

  Future<User> validateOtpAndLogin(String smsCode) async {
    final AuthCredential _authCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: smsCode);

    User _user;
    await _firebaseAuth.signInWithCredential(_authCredential).then((authResult) {
      _user = User.fromFirebaseUser(authResult.user);
    });

    return _user;
  }
}
