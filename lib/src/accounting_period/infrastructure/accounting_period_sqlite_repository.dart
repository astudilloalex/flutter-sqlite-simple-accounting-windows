import 'package:simple_accounting_offline/app/services/sqlite.dart';
import 'package:simple_accounting_offline/src/accounting_period/domain/accounting_period.dart';
import 'package:simple_accounting_offline/src/accounting_period/domain/i_accounting_period_repository.dart';
import 'package:sqflite_common/sqlite_api.dart';

class AccountingPeriodSQLiteRepository implements IAccountingPeriodRepository {
  const AccountingPeriodSQLiteRepository(this._context);

  final SQLite _context;

  @override
  Future<List<AccountingPeriod>> findAll() async {
    final Database db = await _context.database;
    final List<Map<String, Object?>> data = await db.query(
      'periods',
      orderBy: 'creation_date DESC',
    );
    return data.map((map) => AccountingPeriod.fromSQLite(map)).toList();
  }

  @override
  Future<AccountingPeriod> save(AccountingPeriod entity) async {
    final Database db = await _context.database;
    final int id = await db.insert('periods', entity.toSQLite());
    return entity.copyWith(id: id);
  }

  @override
  Future<AccountingPeriod> update(AccountingPeriod entity) async {
    final Database db = await _context.database;
    await db.update('periods', entity.toSQLite());
    return entity;
  }
}
