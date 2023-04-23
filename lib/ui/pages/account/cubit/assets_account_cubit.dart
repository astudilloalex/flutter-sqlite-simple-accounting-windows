import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_accounting_offline/src/account/application/account_service.dart';
import 'package:simple_accounting_offline/src/account/domain/account.dart';
import 'package:simple_accounting_offline/ui/pages/account/cubit/assets_account_state.dart';

class AssetsAccountCubit extends Cubit<AssetsAccountState> {
  AssetsAccountCubit(this._service) : super(const AssetsAccountState());

  final AccountService _service;

  Future<void> load() async {
    final List<Account> accounts = [];
    try {
      accounts.addAll(await _service.getChildrenByCategory(1));
    } finally {
      emit(state.copyWith(loading: false, accounts: accounts));
    }
  }
}
