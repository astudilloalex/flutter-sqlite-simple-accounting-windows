import 'package:decimal/decimal.dart';

class DashboardState {
  const DashboardState({
    this.loading = false,
    this.sixMonthsIncomes = const [],
  });

  final bool loading;
  final List<Decimal> sixMonthsIncomes;

  DashboardState copyWith({
    bool? loading,
    List<Decimal>? sixMonthsIncomes,
  }) {
    return DashboardState(
      loading: loading ?? this.loading,
      sixMonthsIncomes: sixMonthsIncomes ?? this.sixMonthsIncomes,
    );
  }
}
