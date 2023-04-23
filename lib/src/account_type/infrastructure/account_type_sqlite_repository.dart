import 'package:simple_accounting_offline/app/services/sqlite.dart';
import 'package:simple_accounting_offline/src/account_type/domain/account_type.dart';
import 'package:simple_accounting_offline/src/account_type/domain/i_account_type_repository.dart';
import 'package:sqflite_common/sqlite_api.dart';

class AccountTypeSQLiteRepository implements IAccountTypeRepository {
  const AccountTypeSQLiteRepository(this._context);

  final SQLite _context;

  @override
  Future<List<AccountType>> findAll() async {
    final Database db = await _context.database;
    final List<Map<String, Object?>> data = await db.query(
      'account_types',
      orderBy: 'name ASC',
    );
    return data.map((json) => AccountType.fromJson(json)).toList();
  }

  @override
  Future<AccountType?> findByCode(String code) async {
    final Database db = await _context.database;
    final List<Map<String, Object?>> data = await db.query(
      'account_types',
      where: 'code = ?',
      whereArgs: [code],
    );
    if (data.isEmpty) return null;
    return AccountType.fromJson(data.first);
  }

  @override
  Future<AccountType?> findById(int id) async {
    final Database db = await _context.database;
    final List<Map<String, Object?>> data = await db.query(
      'account_types',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (data.isEmpty) return null;
    return AccountType.fromJson(data.first);
  }
}
