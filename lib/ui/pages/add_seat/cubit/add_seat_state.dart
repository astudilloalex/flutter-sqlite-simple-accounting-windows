import 'package:simple_accounting_offline/src/accounting_period/domain/accounting_period.dart';
import 'package:simple_accounting_offline/src/seat_detail/domain/seat_detail.dart';

class AddSeatState {
  const AddSeatState({
    required this.date,
    this.loading = false,
    this.periods = const [],
    this.seatDetails = const [],
    this.selectedPeriodId,
    this.totalCredit = '0.00',
    this.totalDebit = '0.00',
  });

  final DateTime date;
  final bool loading;
  final List<AccountingPeriod> periods;
  final List<SeatDetail> seatDetails;
  final int? selectedPeriodId;
  final String totalCredit;
  final String totalDebit;

  AddSeatState copyWith({
    DateTime? date,
    bool? loading,
    List<AccountingPeriod>? periods,
    List<SeatDetail>? seatDetails,
    int? selectedPeriodId,
    String? totalCredit,
    String? totalDebit,
  }) {
    return AddSeatState(
      date: date ?? this.date,
      loading: loading ?? this.loading,
      periods: periods ?? this.periods,
      seatDetails: seatDetails ?? this.seatDetails,
      selectedPeriodId: selectedPeriodId ?? this.selectedPeriodId,
      totalCredit: totalCredit ?? this.totalCredit,
      totalDebit: totalDebit ?? this.totalDebit,
    );
  }
}
