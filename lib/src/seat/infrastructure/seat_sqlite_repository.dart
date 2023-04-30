import 'package:simple_accounting_offline/app/services/sqlite.dart';
import 'package:simple_accounting_offline/src/seat/domain/i_seat_repository.dart';
import 'package:simple_accounting_offline/src/seat/domain/seat.dart';
import 'package:sqflite_common/sqlite_api.dart';

class SeatSQLiteRepository implements ISeatRepository {
  const SeatSQLiteRepository(this._context);

  final SQLite _context;

  @override
  Future<void> changeState(int id, {required bool cancelled}) async {
    final Database db = await _context.database;
    const String sql = 'UPDATE seats SET canceled = ? WHERE id = ?';
    await db.rawUpdate(sql, [if (cancelled) 1 else 0, id]);
  }

  @override
  Future<List<Seat>> findByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    bool onlyActives = false,
  }) async {
    final Database db = await _context.database;
    final String query = onlyActives
        ? 'SELECT * FROM seats WHERE canceled = ? AND (date BETWEEN ? AND ?)'
        : 'SELECT * FROM seats WHERE date BETWEEN ? AND ?';
    final List<Map<String, Object?>> data = await db.rawQuery(
      query,
      [
        if (onlyActives) 0,
        startDate.copyWith(hour: 0, minute: 0, second: 0).toIso8601String(),
        endDate.copyWith(hour: 23, minute: 59, second: 59).toIso8601String(),
      ],
    );

    return data.map((map) => Seat.fromSQLite(map)).toList();
  }

  @override
  Future<Seat> save(Seat entity) async {
    final Database db = await _context.database;
    final int id = await db.insert(
      'seats',
      entity.toSQLite(),
    );
    return entity.copyWith(id: id);
  }

  @override
  Future<Seat> update(Seat entity) async {
    final Database db = await _context.database;
    await db.update(
      'seats',
      entity.toSQLite(),
      where: 'id = ?',
      whereArgs: [entity.id],
    );
    return entity;
  }
}
