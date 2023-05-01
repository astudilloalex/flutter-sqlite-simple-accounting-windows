import 'package:simple_accounting_offline/app/services/sqlite.dart';
import 'package:simple_accounting_offline/src/user/domain/i_user_repository.dart';
import 'package:simple_accounting_offline/src/user/domain/user.dart';
import 'package:sqflite_common/sqlite_api.dart';

class UserSQLiteRepository implements IUserRepository {
  const UserSQLiteRepository(this._context);

  final SQLite _context;

  @override
  Future<void> changePassword(int id, String password) async {
    final Database db = await _context.database;
    await db.rawUpdate(
      "UPDATE users SET password = ? WHERE id = ?",
      [password, id],
    );
  }

  @override
  Future<void> changeState(int id, {required bool active}) async {
    final Database db = await _context.database;
    await db.rawUpdate(
      "UPDATE users SET active = ? WHERE id = ?",
      [active, id],
    );
  }

  @override
  Future<User?> findById(int id) async {
    final Database db = await _context.database;
    final List<Map<String, Object?>> data = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (data.isEmpty) return null;
    return User.fromJson(data.first);
  }

  @override
  Future<User?> findByUsername(String username) async {
    final Database db = await _context.database;
    final List<Map<String, Object?>> data = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (data.isEmpty) return null;
    return User.fromJson(data.first);
  }

  @override
  Future<User> save(User entity) async {
    final Database db = await _context.database;
    final int id = await db.insert(
      'users',
      entity.toJson(),
    );
    return entity.copyWith(id: id);
  }
}
