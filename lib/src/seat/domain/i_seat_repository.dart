import 'package:simple_accounting_offline/src/seat/domain/seat.dart';

abstract class ISeatRepository {
  const ISeatRepository();

  Future<void> changeState(int id, {required bool cancelled});
  Future<List<Seat>> findByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    bool onlyActives = false,
  });
  Future<Seat> save(Seat entity);
  Future<Seat> update(Seat entity);
}
