import 'package:simple_accounting_offline/src/role/domain/role.dart';

abstract class IRoleRepository {
  const IRoleRepository();

  Future<Role?> findById(int id);
  Future<List<Role>> findByIds(List<int> ids);
}
