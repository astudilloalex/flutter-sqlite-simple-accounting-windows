import 'package:simple_accounting_offline/app/services/sqlite.dart';
import 'package:simple_accounting_offline/src/seat_detail/domain/i_seat_detail_repository.dart';
import 'package:simple_accounting_offline/src/seat_detail/domain/seat_detail.dart';
import 'package:sqflite_common/sqlite_api.dart';

class SeatDetailSQLiteRepository implements ISeatDetailRepository {
  const SeatDetailSQLiteRepository(this._context);

  final SQLite _context;

  @override
  Future<List<SeatDetail>> findAll() async {
    final Database db = await _context.database;
    final List<Map<String, Object?>> data = await db.query('seat_details');
    return data.map((map) => SeatDetail.fromSQLite(map)).toList();
  }

  @override
  Future<List<SeatDetail>> findAllBySeatIds(List<int> seatIds) async {
    final Database db = await _context.database;
    final List<Map<String, Object?>> data = await db.query(
      'seat_details',
      where: 'seat_id IN (${List.filled(seatIds.length, '?').join(',')})',
      whereArgs: seatIds,
    );
    return data.map((map) => SeatDetail.fromSQLite(map)).toList();
  }

  @override
  Future<List<SeatDetail>> findBySeatId(int seatId) async {
    final Database db = await _context.database;
    final List<Map<String, Object?>> data = await db.query(
      'seat_details',
      where: 'seat_id = ?',
      whereArgs: [seatId],
    );
    return data.map((map) => SeatDetail.fromSQLite(map)).toList();
  }

  @override
  Future<SeatDetail> save(SeatDetail entity) async {
    final Database db = await _context.database;
    final int id = await db.insert('seat_details', entity.toSQLite());
    return entity.copyWith(id: id);
  }

  @override
  Future<List<SeatDetail>> saveAll(List<SeatDetail> entities) async {
    final Database db = await _context.database;
    final Batch batch = db.batch();
    for (final SeatDetail element in entities) {
      batch.insert('seat_details', element.toSQLite());
    }
    final List<Object?> data = await batch.commit();
    return entities;
  }

  @override
  Future<SeatDetail> update(SeatDetail entity) async {
    final Database db = await _context.database;
    await db.update(
      'seat_details',
      entity.toSQLite(),
      where: 'id = ?',
      whereArgs: [entity.id],
    );
    return entity;
  }
}
