import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:simple_accounting_offline/src/seat_detail/application/seat_detail_service.dart';
import 'package:simple_accounting_offline/ui/pages/dashboard/cubit/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(
    this._seatDetailService,
  ) : super(const DashboardState());

  final SeatDetailService _seatDetailService;

  Future<void> load() async {
    final DateTime now = DateTime.now();
    final DateTime endDate = DateTime(now.year, now.month + 1).subtract(
      const Duration(days: 1),
    );
    final DateTime startDate = Jiffy().subtract(months: 5).dateTime.copyWith(
          day: 1,
        );
    emit(
      state.copyWith(
        sixMonthsIncomes: await _getIncomes(startDate, endDate),
        sixMonthsExpenses: await _getExpenses(startDate, endDate),
      ),
    );
  }

  Future<List<Decimal>> _getExpenses(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final List<Map<int, Decimal>> incomes =
        await _seatDetailService.getExpenses(
      startDate: startDate,
      endDate: endDate,
    );
    final List<Decimal> data = [];
    int monthNumber = startDate.month - 1;
    for (int i = 0; i < 6; i++) {
      monthNumber += 1;
      if (monthNumber > 12) {
        monthNumber = 1;
      }
      final Map<int, Decimal>? month = incomes.firstWhereOrNull(
        (element) {
          return element.containsKey(monthNumber);
        },
      );
      if (month == null) {
        data.add(Decimal.zero);
      } else {
        data.add(month.values.first);
      }
    }
    return data;
  }

  Future<List<Decimal>> _getIncomes(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final List<Map<int, Decimal>> incomes = await _seatDetailService.getIncomes(
      startDate: startDate,
      endDate: endDate,
    );
    final List<Decimal> data = [];
    int monthNumber = startDate.month - 1;
    for (int i = 0; i < 6; i++) {
      monthNumber += 1;
      if (monthNumber > 12) {
        monthNumber = 1;
      }
      final Map<int, Decimal>? month = incomes.firstWhereOrNull(
        (element) {
          return element.containsKey(monthNumber);
        },
      );
      if (month == null) {
        data.add(Decimal.zero);
      } else {
        data.add(month.values.first);
      }
    }
    return data;
  }
}
