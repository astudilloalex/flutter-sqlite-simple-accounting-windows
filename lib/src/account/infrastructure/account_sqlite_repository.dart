import 'package:simple_accounting_offline/app/services/sqlite.dart';
import 'package:simple_accounting_offline/src/account/domain/account.dart';
import 'package:simple_accounting_offline/src/account/domain/i_account_repository.dart';
import 'package:sqflite_common/sqlite_api.dart';

class AccountSQLiteRepository implements IAccountRepository {
  const AccountSQLiteRepository(this._context);

  final SQLite _context;

  @override
  Future<List<Account>> findAll() {
    // TODO: implement findAll
    throw UnimplementedError();
  }

  @override
  Future<List<Account>> findAllByCodeOrName(String value) {
    // TODO: implement findAllByCodeOrName
    throw UnimplementedError();
  }

  @override
  Future<List<Account>> findByCategoryAndType(
    int categoryId,
    int typeId,
  ) async {
    final Database db = await _context.database;
    final List<Map<String, Object?>> data = await db.query(
      'accounts',
      where: 'account_category_id = ? AND account_type_id = ?',
      whereArgs: [categoryId, typeId],
      orderBy: 'code ASC',
    );
    return data.map((element) => Account.fromJson(element)).toList();
  }

  @override
  Future<Account?> findByCode(String code) async {
    final Database db = await _context.database;
    final List<Map<String, Object?>> data = await db.query(
      'accounts',
      where: 'code = ?',
      whereArgs: [code],
    );
    if (data.isEmpty) return null;
    return Account.fromJson(data.first);
  }

  @override
  Future<List<Account>> findChildrenByCategory(int categoryId) async {
    final Database db = await _context.database;
    final List<Map<String, Object?>> data = await db.query(
      'accounts',
      where: 'parent_id IS NOT NULL AND account_category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'code ASC',
    );
    return data.map((element) => Account.fromJson(element)).toList();
  }

  @override
  Future<Account> save(Account entity) async {
    final Database db = await _context.database;
    final int id = await db.insert('accounts', entity.toSQLite());
    return entity.copyWith(id: id);
  }

  @override
  Future<Account> update(Account entity) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
