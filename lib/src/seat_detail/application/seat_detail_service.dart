import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:simple_accounting_offline/app/services/sqlite.dart';
import 'package:simple_accounting_offline/src/seat/domain/i_seat_repository.dart';
import 'package:simple_accounting_offline/src/seat/domain/seat.dart';
import 'package:simple_accounting_offline/src/seat_detail/domain/i_seat_detail_repository.dart';
import 'package:simple_accounting_offline/src/seat_detail/domain/seat_detail.dart';

class SeatDetailService {
  const SeatDetailService(
    this._repository,
    this._seatRepository,
  );

  final ISeatRepository _seatRepository;
  final ISeatDetailRepository _repository;

  Future<List<SeatDetail>> addAll(List<SeatDetail> seatDetails) {
    for (int i = 0; i < seatDetails.length; i++) {
      seatDetails[i] = seatDetails[i].copyWith(code: generateSQLiteCode());
    }
    return _repository.saveAll(seatDetails);
  }

  Future<List<SeatDetail>> getAllIncomeDetails(List<int> seatIds) {
    return _repository.findAllBySeatIdsAndCategory(seatIds, 4);
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

  Future<List<Map<int, Decimal>>> getIncomes({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final List<Seat> seats = await _seatRepository.findByDateRange(
      startDate: startDate,
      endDate: endDate,
      onlyActives: true,
    );
    final List<SeatDetail> details =
        await _repository.findAllBySeatIdsAndCategory(
      seats.map((e) => e.id ?? 0).toList(),
      4,
    );
    for (int i = 0; i < seats.length; i++) {
      seats[i] = seats[i].copyWith(
        seatDetails:
            details.where((element) => element.seatId == seats[i].id).toList(),
      );
    }
    final List<Map<int, Decimal>> data = [];
    final Map<int, List<Seat>> grouped = groupBy(
      seats.where((element) => element.seatDetails.isNotEmpty),
      (seat) => seat.date.month,
    );
    for (final List<Seat> elements in grouped.values) {
      Decimal total = Decimal.zero;
      for (final Seat seat in elements) {
        for (final SeatDetail detail in seat.seatDetails) {
          total += Decimal.parse(detail.credit.toString());
          total -= Decimal.parse(detail.debit.toString());
        }
      }
      data.add({elements.first.date.month: total});
    }
    return data;
  }
}
