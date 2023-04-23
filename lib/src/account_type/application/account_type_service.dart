import 'package:simple_accounting_offline/src/account_type/domain/account_type.dart';
import 'package:simple_accounting_offline/src/account_type/domain/i_account_type_repository.dart';

class AccountTypeService {
  const AccountTypeService(this._repository);

  final IAccountTypeRepository _repository;

  Future<List<AccountType>> getAll() {
    return _repository.findAll();
  }
}
