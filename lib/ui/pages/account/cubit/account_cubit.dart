import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_accounting_offline/src/account/application/account_service.dart';
import 'package:simple_accounting_offline/src/account/domain/account.dart';
import 'package:simple_accounting_offline/ui/pages/account/cubit/account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit(this._service) : super(const AccountState());

  final AccountService _service;

  void onChangeTab(int index) {
    emit(state.copyWith(currentTab: index));
  }

  Future<String?> saveAccount(Account entity) async {
    try {
      await _service.add(entity);
    } on Exception catch (e) {
      return e.toString();
    }
    return null;
  }
}
