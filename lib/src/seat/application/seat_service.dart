import 'package:simple_accounting_offline/app/services/get_storage_service.dart';
import 'package:simple_accounting_offline/app/services/sqlite.dart';
import 'package:simple_accounting_offline/src/seat/domain/i_seat_repository.dart';
import 'package:simple_accounting_offline/src/seat/domain/seat.dart';

class SeatService {
  const SeatService(this._repository, this._storageService);

  final ISeatRepository _repository;
  final GetStorageService _storageService;

  Future<Seat> add(Seat seat) {
    return _repository.save(
      seat.copyWith(
        code: generateSQLiteCode(),
        userId: _storageService.currentUserId,
      ),
    );
  }

  Future<Seat> update(Seat seat) {
    return _repository.update(
      seat.copyWith(userId: _storageService.currentUserId),
    );
  }

  Future<List<Seat>> getByPeriod({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _repository.findByDateRange(startDate: startDate, endDate: endDate);
  }
}
