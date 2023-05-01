import 'package:simple_accounting_offline/src/role/domain/i_role_repository.dart';
import 'package:simple_accounting_offline/src/role/domain/role.dart';

class RoleService {
  const RoleService(this._repository);

  final IRoleRepository _repository;

  Future<List<Role>> getAll() {
    return _repository.findAll();
  }

  Future<List<Role>> getByIds(List<int> ids) {
    return _repository.findByIds(ids);
  }
}
