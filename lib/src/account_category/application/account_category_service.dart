import 'package:simple_accounting_offline/src/account_category/domain/account_category.dart';
import 'package:simple_accounting_offline/src/account_category/domain/i_account_category_repository.dart';

class AccountCategoryService {
  const AccountCategoryService(this._repository);

  final IAccountCategoryRepository _repository;

  Future<List<AccountCategory>> getAll() {
    return _repository.findAll();
  }
}
