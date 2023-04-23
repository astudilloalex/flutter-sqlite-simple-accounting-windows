import 'package:simple_accounting_offline/src/account_category/domain/account_category.dart';

abstract class IAccountCategoryRepository {
  const IAccountCategoryRepository();

  Future<List<AccountCategory>> findAll();
}
