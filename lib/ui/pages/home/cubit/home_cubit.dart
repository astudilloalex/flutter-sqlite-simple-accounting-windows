import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_accounting_offline/ui/pages/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void changeCurrentIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  void changeExpandedRail() {
    emit(state.copyWith(extendedRail: !state.extendedRail));
  }
}
