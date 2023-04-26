import 'package:simple_accounting_offline/src/accounting_period/domain/accounting_period.dart';

class AddSeatState {
  const AddSeatState({
    this.periods = const [],
    this.totalCredit = '0.00',
    this.totalDebit = '0.00',
  });

  final List<AccountingPeriod> periods;
  final String totalCredit;
  final String totalDebit;

  AddSeatState copyWith({
    List<AccountingPeriod>? periods,
    String? totalCredit,
    String? totalDebit,
  }) {
    return AddSeatState(
      periods: periods ?? this.periods,
      totalCredit: totalCredit ?? this.totalCredit,
      totalDebit: totalDebit ?? this.totalDebit,
    );
  }
}
