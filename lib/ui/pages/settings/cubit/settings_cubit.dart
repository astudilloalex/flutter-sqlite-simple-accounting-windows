import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_accounting_offline/src/accounting_period/application/accounting_period_service.dart';
import 'package:simple_accounting_offline/src/accounting_period/domain/accounting_period.dart';
import 'package:simple_accounting_offline/src/user/application/user_service.dart';
import 'package:simple_accounting_offline/src/user/domain/user.dart';
import 'package:simple_accounting_offline/ui/pages/settings/cubit/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(
    this._accountingPeriodService,
    this._userService,
  ) : super(const SettingsState());

  final AccountingPeriodService _accountingPeriodService;
  final UserService _userService;

  Future<void> load([int tabIndex = 0]) async {
    final List<AccountingPeriod> periods = [];
    final List<User> users = [];
    try {
      emit(state.copyWith(loading: true, currentTab: tabIndex));
      switch (tabIndex) {
        case 0:
          periods.addAll(await _accountingPeriodService.getAll());
          break;
        case 1:
          users.addAll(await _userService.getAll());
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
          await _accountingPeriodService.findByYear(period.startDate);
      if (finded != null) return 'already-exists-period-in-the-year';
      await _accountingPeriodService.save(period);
      await load();
    } on Exception catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<String?> updatePeriod(AccountingPeriod period) async {
    try {
      final AccountingPeriod? finded =
          await _accountingPeriodService.findByYear(period.startDate);
      if (finded != null && finded.id != period.id) {
        return 'already-exists-period-in-the-year';
      }
      await _accountingPeriodService.update(period);
      await load();
    } on Exception catch (e) {
      return e.toString();
    }
    return null;
  }
}
