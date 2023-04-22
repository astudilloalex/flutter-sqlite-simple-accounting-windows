import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_accounting_offline/ui/pages/sign_in/cubit/sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(const SignInState());
}
