import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:simple_accounting_offline/app/exception.dart';
import 'package:simple_accounting_offline/app/services/sqlite.dart';
import 'package:simple_accounting_offline/src/user/domain/i_user_repository.dart';
import 'package:simple_accounting_offline/src/user/domain/user.dart';

class UserService {
  const UserService(this._repository);

  final IUserRepository _repository;

  Future<User> save(User user) {
    return _repository.save(
      user.copyWith(
        code: generateSQLiteCode(),
        password: BCrypt.hashpw(user.password, BCrypt.gensalt()),
      ),
    );
  }

  Future<User?> verifySession(String payload) async {
    final Map<String, Object?> data =
        json.decode(payload) as Map<String, Object?>;
    final DateTime? date = DateTime.tryParse(data['expiration']! as String);
    if (date == null) return null;
    if (date.isBefore(DateTime.now())) return null;
    return _repository.findByUsername(data['username']! as String);
  }

  Future<String> signIn(String username, String password) async {
    final User? user = await _repository.findByUsername(username.trim());
    if (user == null) throw const BadCredentialException('user-not-found');
    if (!user.active) throw const AccountException('user-disabled');
    if (!BCrypt.checkpw(password, user.password)) {
      throw const AccountException('wrong-password');
    }
    // This is a local program do not need encrypt data.
    final Map<String, Object?> payload = {
      'userId': user.id,
      'username': user.username,
      'roleId': user.roleId,
      'expiration':
          DateTime.now().add(const Duration(hours: 15)).toIso8601String(),
      'issuer': 'https://www.alexastudillo.com/',
    };
    return json.encode(payload);
  }
}
