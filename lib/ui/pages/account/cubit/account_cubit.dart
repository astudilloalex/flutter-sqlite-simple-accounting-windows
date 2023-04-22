import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_accounting_offline/ui/pages/account/cubit/account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(const AccountState());
}
