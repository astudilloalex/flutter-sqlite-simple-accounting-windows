import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_accounting_offline/src/account/application/account_service.dart';
import 'package:simple_accounting_offline/src/account/domain/account.dart';
import 'package:simple_accounting_offline/src/accounting_period/application/accounting_period_service.dart';
import 'package:simple_accounting_offline/src/accounting_period/domain/accounting_period.dart';
import 'package:simple_accounting_offline/src/seat/application/seat_service.dart';
import 'package:simple_accounting_offline/src/seat/domain/seat.dart';
import 'package:simple_accounting_offline/src/seat_detail/domain/seat_detail.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/cubit/add_seat_state.dart';

class AddSeatCubit extends Cubit<AddSeatState> {
  AddSeatCubit(
    this._periodService,
    this._accountService,
    this._seatService,
  ) : super(AddSeatState(date: DateTime.now()));

  final AccountingPeriodService _periodService;
  final AccountService _accountService;
  final SeatService _seatService;

  String description = '';

  Future<void> load() async {
    final List<AccountingPeriod> periods = [];
    try {
      periods.addAll(await _periodService.getAll());
    } finally {
      emit(
        state.copyWith(
          periods: periods,
          selectedPeriodId: periods.firstOrNull?.id,
        ),
      );
    }
  }

  Future<List<Account>> get accounts {
    return _accountService.getChildrenByCategory(2);
  }

  Future<String?> saveSeat() async {
    try {
      if (state.selectedPeriodId == null) {
        return 'select-a-period';
      }
      if (state.seatDetails.isEmpty) {
        return 'add-seat-details';
      }
      emit(state.copyWith(loading: true));
      await _seatService.add(
        Seat(
          date: state.date,
          description: description,
          periodId: state.selectedPeriodId ?? 0,
          seatDetails: state.seatDetails,
        ),
      );
    } on Exception catch (e) {
      return e.toString();
    } finally {
      emit(state.copyWith(loading: false));
    }
    return null;
  }

  void changeDate(DateTime dateTime) {
    emit(state.copyWith(date: dateTime));
  }

  void changePeriod(int? period) {
    emit(state.copyWith(selectedPeriodId: period));
  }

  void addOrUpdateSeatDetail(SeatDetail detail) {
    final List<SeatDetail> details = [...state.seatDetails];
    if (detail.id == null) {
      details.add(detail);
    } else {
      final int i = details.indexWhere((element) => element.id == detail.id);
      if (i >= 0) {
        details[i] = detail;
      }
    }
    Decimal totalCredit = Decimal.zero;
    Decimal totalDebit = Decimal.zero;
    for (final SeatDetail element in details) {
      totalCredit += Decimal.parse(element.credit.toString());
      totalDebit += Decimal.parse(element.debit.toString());
    }
    emit(
      state.copyWith(
        seatDetails: details,
        totalCredit: totalCredit.toString(),
        totalDebit: totalDebit.toString(),
      ),
    );
  }
}
