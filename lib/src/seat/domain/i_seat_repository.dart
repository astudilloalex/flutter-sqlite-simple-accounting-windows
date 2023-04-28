import 'package:simple_accounting_offline/src/seat/domain/seat.dart';

abstract class ISeatRepository {
  const ISeatRepository();

  Future<List<Seat>> findByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  });
  Future<Seat> save(Seat entity);
  Future<Seat> update(Seat entity);
}
