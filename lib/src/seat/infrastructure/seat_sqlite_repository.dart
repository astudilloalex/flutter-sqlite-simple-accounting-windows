import 'package:intl/intl.dart';
import 'package:simple_accounting_offline/app/services/sqlite.dart';
import 'package:simple_accounting_offline/src/seat/domain/i_seat_repository.dart';
import 'package:simple_accounting_offline/src/seat/domain/seat.dart';
import 'package:sqflite_common/sqlite_api.dart';

class SeatSQLiteRepository implements ISeatRepository {
  const SeatSQLiteRepository(this._context);

  final SQLite _context;

  @override
  Future<List<Seat>> findByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final Database db = await _context.database;
    final List<Map<String, Object?>> data = await db.rawQuery(
      'SELECT * FROM seats WHERE date BETWEEN ? AND ?',
      [
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
