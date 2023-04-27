import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_accounting_offline/src/account/application/account_service.dart';
import 'package:simple_accounting_offline/src/account/domain/account.dart';
import 'package:simple_accounting_offline/src/accounting_period/application/accounting_period_service.dart';
import 'package:simple_accounting_offline/src/accounting_period/domain/accounting_period.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/cubit/add_seat_state.dart';

class AddSeatCubit extends Cubit<AddSeatState> {
  AddSeatCubit(
    this._periodService,
    this._accountService,
  ) : super(const AddSeatState());

  final AccountingPeriodService _periodService;
  final AccountService _accountService;

  Future<void> load() async {
    final List<AccountingPeriod> periods = [];
    try {
      periods.addAll(await _periodService.getAll());
    } finally {
      emit(state.copyWith(periods: periods));
    }
  }

  Future<List<Account>> get accounts {
    return _accountService.getChildrenByCategory(2);
  }
}
