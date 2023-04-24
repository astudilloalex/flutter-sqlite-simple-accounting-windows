import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_accounting_offline/app/exception.dart';
import 'package:simple_accounting_offline/app/services/get_storage_service.dart';
import 'package:simple_accounting_offline/src/user/application/user_service.dart';
import 'package:simple_accounting_offline/ui/pages/sign_in/cubit/sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(
    this._service,
    this._storageService,
  ) : super(const SignInState());

  final UserService _service;
  final GetStorageService _storageService;

  void changePasswordVisibility() {
    emit(state.copyWith(viewPassword: !state.viewPassword));
  }

  void changeRemember() {
    emit(state.copyWith(remember: !state.remember));
  }

  Future<String?> signIn(
    String username,
    String password,
  ) async {
    try {
      emit(state.copyWith(loading: true));
      final String payload = await _service.signIn(username, password);
      if (state.remember) {
        await _storageService.savePayloadSession(payload);
      } else {
        final Map<String, Object?> data =
            json.decode(payload) as Map<String, Object?>;
        data.remove('expiration');
        data.addAll({'expiration': DateTime.now().toIso8601String()});
        await _storageService.savePayloadSession(payload);
      }
    } on UnauthorizedException catch (e) {
      return e.code;
    } finally {
      emit(state.copyWith(loading: false));
    }
    return null;
  }
}
