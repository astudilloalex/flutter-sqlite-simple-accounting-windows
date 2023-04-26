import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/cubit/add_seat_form_state.dart';

class AddSeatFormCubit extends Cubit<AddSeatFormState> {
  AddSeatFormCubit() : super(AddSeatFormState(date: DateTime.now()));

  String description = '';

  void changePeriod(int? periodId) {
    emit(state.copyWith(selectedPeriodId: periodId));
  }
}
