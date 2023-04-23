import 'package:simple_accounting_offline/src/account/domain/account.dart';

class AssetsAccountState {
  const AssetsAccountState({
    this.accounts = const [],
    this.loading = false,
  });

  final List<Account> accounts;
  final bool loading;

  AssetsAccountState copyWith({
    List<Account>? accounts,
    bool? loading,
  }) {
    return AssetsAccountState(
      accounts: accounts ?? this.accounts,
      loading: loading ?? this.loading,
    );
  }
}
