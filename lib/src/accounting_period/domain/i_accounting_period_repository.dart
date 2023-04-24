import 'package:simple_accounting_offline/src/accounting_period/domain/accounting_period.dart';

abstract class IAccountingPeriodRepository {
  const IAccountingPeriodRepository();

  Future<List<AccountingPeriod>> findAll();
  Future<AccountingPeriod> save(AccountingPeriod entity);
  Future<AccountingPeriod> update(AccountingPeriod entity);
}
