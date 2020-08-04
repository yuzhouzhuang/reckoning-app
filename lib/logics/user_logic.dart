import '../entities/entities.dart';
import '../respositories/respositories.dart';

class UserLogic {
  final FirebaseUserInfoRepository userInfoRepository = FirebaseUserInfoRepository();

  Future<void> addNewUser(String uid, String phone) {
    return userInfoRepository.addNewUserEntity(UserEntity(uid, "default", phone));
  }

  Future<Map<String, Object>> getUserEntity(String uid) {
    return userInfoRepository.getUserEntity(uid).then((value) => value.toJson());
  }

  Future<void> updateUser(String uid, String userName, String phone) {
    return userInfoRepository.updateUserEntity(UserEntity(uid, userName, phone));
  }
}
