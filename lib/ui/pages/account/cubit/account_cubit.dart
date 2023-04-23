import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_accounting_offline/src/account/application/account_service.dart';
import 'package:simple_accounting_offline/src/account/domain/account.dart';
import 'package:simple_accounting_offline/ui/pages/account/cubit/account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit(this._service) : super(const AccountState());

  final AccountService _service;

  void onChangeTab(int index) {
    loadAccounts(index + 1);
  }

  Future<String?> saveAccount(Account entity) async {
    try {
      await _service.add(entity);
      await loadAccounts(entity.accountCategoryId);
    } on Exception catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<void> loadAccounts(int categoryId) async {
    final List<Account> accounts = [];
    try {
      emit(state.copyWith(loading: true));
      accounts.addAll(await _service.getChildrenByCategory(categoryId));
    } finally {
      emit(state.copyWith(loading: false, accounts: accounts));
    }
  }

  Future<String?> updateAccount(Account entity) async {
    try {
      await _service.update(entity);
      await loadAccounts(entity.accountCategoryId);
    } on Exception catch (e) {
      return e.toString();
    }
    return null;
  }
}
