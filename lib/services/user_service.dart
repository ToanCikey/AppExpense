import 'package:doancuoiky/models/users.dart';
import 'package:doancuoiky/repositories/user_repository.dart';

class UserService {
  final UserRepository _user = UserRepository();

  Future<void> saveUser(Users user) async {
    _user.saveUser(user);
  }

  Future<Users?> getUser(String id) async {
    return _user.getUser(id);
  }
}
