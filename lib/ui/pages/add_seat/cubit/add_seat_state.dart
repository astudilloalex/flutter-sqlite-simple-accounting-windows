import 'package:simple_accounting_offline/src/accounting_period/domain/accounting_period.dart';
import 'package:simple_accounting_offline/src/seat_detail/domain/seat_detail.dart';

class AddSeatState {
  const AddSeatState({
    this.periods = const [],
    this.seatDetails = const [],
    this.totalCredit = '0.00',
    this.totalDebit = '0.00',
  });

  final List<AccountingPeriod> periods;
  final List<SeatDetail> seatDetails;
  final String totalCredit;
  final String totalDebit;

  AddSeatState copyWith({
    List<AccountingPeriod>? periods,
    List<SeatDetail>? seatDetails,
    String? totalCredit,
    String? totalDebit,
  }) {
    return AddSeatState(
      periods: periods ?? this.periods,
      seatDetails: seatDetails ?? this.seatDetails,
      totalCredit: totalCredit ?? this.totalCredit,
      totalDebit: totalDebit ?? this.totalDebit,
    );
  }
}
