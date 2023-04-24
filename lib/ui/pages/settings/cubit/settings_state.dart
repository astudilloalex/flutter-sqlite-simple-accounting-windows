import 'package:simple_accounting_offline/src/accounting_period/domain/accounting_period.dart';
import 'package:simple_accounting_offline/src/user/domain/user.dart';

class SettingsState {
  const SettingsState({
    this.currentTab = 0,
    this.loading = false,
    this.periods = const [],
    this.users = const [],
  });

  final int currentTab;
  final bool loading;
  final List<AccountingPeriod> periods;
  final List<User> users;

  SettingsState copyWith({
    int? currentTab,
    bool? loading,
    List<AccountingPeriod>? periods,
    List<User>? users,
  }) {
    return SettingsState(
      currentTab: currentTab ?? this.currentTab,
      loading: loading ?? this.loading,
      periods: periods ?? this.periods,
      users: users ?? this.users,
    );
  }
}
