import 'package:simple_accounting_offline/app/services/sqlite.dart';
import 'package:simple_accounting_offline/src/seat_detail/domain/i_seat_detail_repository.dart';
import 'package:simple_accounting_offline/src/seat_detail/domain/seat_detail.dart';

class SeatDetailService {
  const SeatDetailService(this._repository);

  final ISeatDetailRepository _repository;

  Future<List<SeatDetail>> addAll(List<SeatDetail> seatDetails) {
    for (int i = 0; i < seatDetails.length; i++) {
      seatDetails[i] = seatDetails[i].copyWith(code: generateSQLiteCode());
    }
    return _repository.saveAll(seatDetails);
  }

  Future<SeatDetail> add(SeatDetail seatDetail) {
    return _repository.save(seatDetail.copyWith(code: generateSQLiteCode()));
  }

  Future<SeatDetail> update(SeatDetail seatDetail) {
    return _repository.update(seatDetail);
  }

  Future<List<SeatDetail>> getBySeatId(int seatId) {
    return _repository.findBySeatId(seatId);
  }
}
