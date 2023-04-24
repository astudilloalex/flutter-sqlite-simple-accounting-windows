import 'package:simple_accounting_offline/app/services/get_storage_service.dart';
import 'package:simple_accounting_offline/app/services/sqlite.dart';
import 'package:simple_accounting_offline/src/accounting_period/domain/accounting_period.dart';
import 'package:simple_accounting_offline/src/accounting_period/domain/i_accounting_period_repository.dart';

class AccountingPeriodService {
  const AccountingPeriodService(
    this._repository,
    this._storageService,
  );

  final IAccountingPeriodRepository _repository;
  final GetStorageService _storageService;

  Future<List<AccountingPeriod>> getAll() {
    return _repository.findAll();
  }

  Future<AccountingPeriod> save(AccountingPeriod entity) {
    return _repository.save(
      entity.copyWith(
        code: generateSQLiteCode(),
        active: true,
        name: entity.name.trim().toUpperCase(),
        userId: _storageService.currentUserId,
      ),
    );
  }

  Future<AccountingPeriod> update(AccountingPeriod entity) {
    return _repository.save(
      entity.copyWith(
        name: entity.name.trim().toUpperCase(),
        userId: _storageService.currentUserId,
      ),
    );
  }
}
