import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_accounting_offline/src/seat/application/seat_service.dart';
import 'package:simple_accounting_offline/src/seat/domain/seat.dart';
import 'package:simple_accounting_offline/ui/pages/detail/cubit/detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  DetailCubit(
    this._seatService,
  ) : super(
          DetailState(
            endDate: DateTime.now().copyWith(hour: 23, minute: 59, second: 59),
            startDate: DateTime.now().copyWith(
              day: 1,
              hour: 0,
              minute: 0,
              second: 0,
            ),
          ),
        );

  final SeatService _seatService;

  Future<void> load() async {
    final List<Seat> seats = [];
    try {
      emit(state.copyWith(loading: true));
      seats.addAll(
        await _seatService.getByPeriod(
          startDate: state.startDate,
          endDate: state.endDate,
        ),
      );
    } finally {
      emit(state.copyWith(seats: seats, loading: false));
    }
  }

  void changeDates(DateTimeRange range) {
    emit(state.copyWith(startDate: range.start, endDate: range.end));
    load();
  }

  Future<void> changeState(int id, {required bool cancelled}) async {
    await _seatService.changeState(id, cancelled: cancelled);
    final List<Seat> seats = [...state.seats];
    final int index = seats.indexWhere((element) => element.id == id);
    if (index >= 0) {
      seats[index] = seats[index].copyWith(cancelled: cancelled);
    }
    emit(state.copyWith(seats: seats));
  }
}
