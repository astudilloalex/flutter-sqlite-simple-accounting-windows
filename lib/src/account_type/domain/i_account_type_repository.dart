import 'package:simple_accounting_offline/src/account_type/domain/account_type.dart';

abstract class IAccountTypeRepository {
  const IAccountTypeRepository();

  Future<List<AccountType>> findAll();
  Future<AccountType?> findById(int id);
  Future<AccountType?> findByCode(String code);
}
