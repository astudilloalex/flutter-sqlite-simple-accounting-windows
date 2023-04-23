import 'package:simple_accounting_offline/app/services/sqlite.dart';
import 'package:simple_accounting_offline/src/account_category/domain/account_category.dart';
import 'package:simple_accounting_offline/src/account_category/domain/i_account_category_repository.dart';
import 'package:sqflite_common/sqlite_api.dart';

class AccountCategorySQLiteRepository implements IAccountCategoryRepository {
  const AccountCategorySQLiteRepository(this._context);

  final SQLite _context;

  @override
  Future<List<AccountCategory>> findAll() async {
    final Database db = await _context.database;
    final List<Map<String, Object?>> data = await db.query(
      'account_categories',
      orderBy: 'name ASC',
    );
    return data.map((json) => AccountCategory.fromJson(json)).toList();
  }
}
