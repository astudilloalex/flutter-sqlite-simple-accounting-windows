import 'package:simple_accounting_offline/src/user/domain/user.dart';

abstract class IUserRepository {
  const IUserRepository();

  Future<void> changePassword(String password);
  Future<void> changeState({required bool active});
  Future<User?> findByUsername(String username);
  Future<User> save(User entity);
}
