import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_accounting_offline/src/accounting_period/application/accounting_period_service.dart';
import 'package:simple_accounting_offline/src/accounting_period/domain/accounting_period.dart';
import 'package:simple_accounting_offline/src/user/domain/user.dart';
import 'package:simple_accounting_offline/ui/pages/settings/cubit/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._service) : super(const SettingsState());

  final AccountingPeriodService _service;

  Future<void> load([int tabIndex = 0]) async {
    final List<AccountingPeriod> periods = [];
    final List<User> users = [];
    try {
      emit(state.copyWith(loading: true, currentTab: tabIndex));
      switch (tabIndex) {
        case 0:
          periods.addAll(await _service.getAll());
          break;
        case 1:
          break;
      }
    } finally {
      emit(
        state.copyWith(
          loading: false,
          users: users,
          periods: periods,
        ),
      );
    }
  }

  Future<String?> addPeriod(AccountingPeriod period) async {
    try {
      final AccountingPeriod? finded =
          await _service.findByYear(period.startDate);
      if (finded != null) return 'already-exists-period-in-the-year';
      await _service.save(period);
      await load();
    } on Exception catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<String?> updatePeriod(AccountingPeriod period) async {
    try {
      final AccountingPeriod? finded =
          await _service.findByYear(period.startDate);
      if (finded != null && finded.id != period.id) {
        return 'already-exists-period-in-the-year';
      }
      await _service.update(period);
      await load();
    } on Exception catch (e) {
      return e.toString();
    }
    return null;
  }
}
