import 'package:simple_accounting_offline/app/services/get_storage_service.dart';
import 'package:simple_accounting_offline/src/account/domain/account.dart';
import 'package:simple_accounting_offline/src/account/domain/i_account_repository.dart';

class AccountService {
  const AccountService(this._repository, this._storageService);

  final IAccountRepository _repository;
  final GetStorageService _storageService;

  Future<List<Account>> getAvailableParentsByCategory(int categoryId) {
    return _repository.findByCategoryAndType(categoryId, 1);
  }

  Future<List<Account>> getChildrenByCategory(int categoryId) {
    return _repository.findChildrenByCategory(categoryId);
  }

  Future<Account?> getByCode(String code) {
    return _repository.findByCode(code.trim());
  }

  Future<Account?> add(Account account) {
    return _repository.save(
      account.copyWith(
        code: account.code.trim().toUpperCase(),
        name: account.name.trim().toUpperCase(),
        description: account.description?.trim().toUpperCase(),
        userId: _storageService.currentUserId,
      ),
    );
  }
}
