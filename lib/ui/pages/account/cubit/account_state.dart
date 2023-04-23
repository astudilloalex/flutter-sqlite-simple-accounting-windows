import 'package:simple_accounting_offline/src/account/domain/account.dart';

class AccountState {
  const AccountState({
    this.accounts = const [],
    this.currentTab = 0,
    this.loading = false,
  });

  final List<Account> accounts;
  final int currentTab;
  final bool loading;

  AccountState copyWith({
    List<Account>? accounts,
    int? currentTab,
    bool? loading,
  }) {
    return AccountState(
      accounts: accounts ?? this.accounts,
      currentTab: currentTab ?? this.currentTab,
      loading: loading ?? this.loading,
    );
  }
}
