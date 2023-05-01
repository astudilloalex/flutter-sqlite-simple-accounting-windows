import 'package:simple_accounting_offline/src/user/domain/user.dart';

abstract class IUserRepository {
  const IUserRepository();

  Future<void> changePassword(int id, String password);
  Future<void> changeState(int id, {required bool active});
  Future<User?> findById(int id);
  Future<User?> findByUsername(String username);
  Future<User> save(User entity);
}
