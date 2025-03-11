import 'package:doancuoiky/models/users.dart';
import 'package:doancuoiky/services/user_service.dart';

class UserRepository {
  final UserService _userService = UserService();

  Future<void> saveUser(Users user) async {
    _userService.saveUser(user);
  }

  Future<Users?> getUser(String id) async {
    return _userService.getUser(id);
  }
}
