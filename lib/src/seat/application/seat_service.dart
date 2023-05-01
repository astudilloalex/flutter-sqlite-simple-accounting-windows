import 'package:simple_accounting_offline/app/services/get_storage_service.dart';
import 'package:simple_accounting_offline/app/services/sqlite.dart';
import 'package:simple_accounting_offline/src/seat/domain/i_seat_repository.dart';
import 'package:simple_accounting_offline/src/seat/domain/seat.dart';
import 'package:simple_accounting_offline/src/seat_detail/domain/i_seat_detail_repository.dart';
import 'package:simple_accounting_offline/src/seat_detail/domain/seat_detail.dart';

class SeatService {
  const SeatService(
    this._repository,
    this._seatDetailRepository,
    this._storageService,
  );

  final ISeatRepository _repository;
  final ISeatDetailRepository _seatDetailRepository;
  final GetStorageService _storageService;

  Future<void> changeState(int id, {required bool cancelled}) {
    return _repository.changeState(id, cancelled: cancelled);
  }

  Future<Seat> add(Seat seat) async {
    final Seat saved = await _repository.save(
      seat.copyWith(
        code: generateSQLiteCode(),
        userId: _storageService.currentUserId,
      ),
    );
    final List<SeatDetail> details = [...seat.seatDetails];
    for (int i = 0; i < details.length; i++) {
      details[i] = details[i].copyWith(
        code: generateSQLiteCode(),
        seatId: saved.id,
      );
    }
    return saved.copyWith(
      seatDetails: await _seatDetailRepository.saveAll(details),
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
