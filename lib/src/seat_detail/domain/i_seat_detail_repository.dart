import 'package:simple_accounting_offline/src/seat_detail/domain/seat_detail.dart';

abstract class ISeatDetailRepository {
  const ISeatDetailRepository();

  Future<List<SeatDetail>> findAll();
  Future<List<SeatDetail>> findAllBySeatIds(List<int> seatId);
  Future<List<SeatDetail>> findBySeatId(int seatId);
  Future<SeatDetail> save(SeatDetail entity);
  Future<List<SeatDetail>> saveAll(List<SeatDetail> entities);
  Future<SeatDetail> update(SeatDetail entity);
}
