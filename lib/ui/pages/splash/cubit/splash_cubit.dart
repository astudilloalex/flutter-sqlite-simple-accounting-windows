import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_accounting_offline/app/services/get_storage_service.dart';
import 'package:simple_accounting_offline/src/user/application/user_service.dart';
import 'package:simple_accounting_offline/src/user/domain/user.dart';
import 'package:simple_accounting_offline/ui/pages/splash/cubit/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._service, this._storageService) : super(const SplashState());

  final UserService _service;
  final GetStorageService _storageService;

  Future<bool> authenticated() async {
    try {
      emit(state.copyWith(loading: true));
      final String? payload = _storageService.sessionPayload;
      if (payload == null) return false;
      final User? user = await _service.verifySession(payload);
      if (user == null) return false;
    } finally {
      emit(state.copyWith(loading: false));
    }
    return true;
  }
}
