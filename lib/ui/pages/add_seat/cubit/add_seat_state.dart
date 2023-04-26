import 'package:simple_accounting_offline/src/accounting_period/domain/accounting_period.dart';

class AddSeatState {
  const AddSeatState({
    this.periods = const [],
  });

  final List<AccountingPeriod> periods;

  AddSeatState copyWith({
    List<AccountingPeriod>? periods,
  }) {
    return AddSeatState(
      periods: periods ?? this.periods,
    );
  }
}
