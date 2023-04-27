import 'package:simple_accounting_offline/src/account/domain/account.dart';

abstract class IAccountRepository {
  const IAccountRepository();

  Future<List<Account>> findAll();
  Future<List<Account>> findAllByCodeOrName(String value);
  Future<List<Account>> findByCategoryAndType(int categoryId, int typeId);
  Future<Account?> findByCode(String code);
  Future<List<Account>> findChildrenByCategory(int categoryId);
  Future<List<Account>> findMovementAccounts();
  Future<Account> save(Account entity);
  Future<Account> update(Account entity);
}
