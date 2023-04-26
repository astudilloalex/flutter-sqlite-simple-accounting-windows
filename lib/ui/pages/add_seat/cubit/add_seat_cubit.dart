import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_accounting_offline/src/accounting_period/application/accounting_period_service.dart';
import 'package:simple_accounting_offline/src/accounting_period/domain/accounting_period.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/cubit/add_seat_state.dart';

class AddSeatCubit extends Cubit<AddSeatState> {
  AddSeatCubit(
    this._periodService,
  ) : super(const AddSeatState());

  final AccountingPeriodService _periodService;

  Future<void> load() async {
    final List<AccountingPeriod> periods = [];
    try {
      periods.addAll(await _periodService.getAll());
    } finally {
      emit(state.copyWith(periods: periods));
    }
  }
}
