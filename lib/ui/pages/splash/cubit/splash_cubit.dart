import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_accounting_offline/src/user/application/user_service.dart';
import 'package:simple_accounting_offline/ui/pages/splash/cubit/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._service) : super(const SplashState());

  final UserService _service;

  Future<void> load() async {}
}
