import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_accounting_offline/app/services/get_storage_service.dart';
import 'package:simple_accounting_offline/ui/pages/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._storageService) : super(const HomeState());

  final GetStorageService _storageService;

  void changeCurrentIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  void changeExpandedRail() {
    emit(state.copyWith(extendedRail: !state.extendedRail));
  }

  int get roleId {
    return _storageService.currentRoleId ?? 3;
  }

  void logout() {
    _storageService.savePayloadSession(null);
  }
}
