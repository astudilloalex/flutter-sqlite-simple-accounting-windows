import 'package:simple_accounting_offline/app/services/sqlite.dart';
import 'package:simple_accounting_offline/src/role/domain/i_role_repository.dart';
import 'package:simple_accounting_offline/src/role/domain/role.dart';
import 'package:sqflite_common/sqlite_api.dart';

class RoleSQLiteRepository implements IRoleRepository {
  const RoleSQLiteRepository(this._context);

  final SQLite _context;

  @override
  Future<List<Role>> findAll() async {
    final Database db = await _context.database;
    final List<Map<String, Object?>> data = await db.query('roles');
    return data.map((map) => Role.fromSQLite(map)).toList();
  }

  @override
  Future<Role?> findById(int id) async {
    final Database db = await _context.database;
    final List<Map<String, Object?>> data = await db.query(
      'roles',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (data.isEmpty) return null;
    return Role.fromSQLite(data.first);
  }

  @override
  Future<List<Role>> findByIds(List<int> ids) async {
    final Database db = await _context.database;
    final List<Map<String, Object?>> data = await db.query(
      'roles',
      where: 'id IN (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
    return data.map((map) => Role.fromSQLite(map)).toList();
  }
}
