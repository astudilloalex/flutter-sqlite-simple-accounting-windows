import 'package:decimal/decimal.dart';

class DashboardState {
  const DashboardState({
    this.loading = false,
    this.sixMonthsExpenses = const [],
    this.sixMonthsIncomes = const [],
  });

  final bool loading;
  final List<Decimal> sixMonthsExpenses;
  final List<Decimal> sixMonthsIncomes;

  DashboardState copyWith({
    bool? loading,
    List<Decimal>? sixMonthsExpenses,
    List<Decimal>? sixMonthsIncomes,
  }) {
    return DashboardState(
      loading: loading ?? this.loading,
      sixMonthsExpenses: sixMonthsExpenses ?? this.sixMonthsExpenses,
      sixMonthsIncomes: sixMonthsIncomes ?? this.sixMonthsIncomes,
    );
  }
}
