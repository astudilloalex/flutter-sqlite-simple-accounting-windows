import 'package:get_it/get_it.dart';
import 'package:simple_accounting_offline/app/services/sqlite.dart';
import 'package:simple_accounting_offline/src/user/domain/i_user_repository.dart';
import 'package:simple_accounting_offline/src/user/infrastructure/user_sqlite_repository.dart';

GetIt getIt = GetIt.instance;

void setUpGetIt() {
  // Register singleton SQLite service.
  getIt.registerSingleton<SQLite>(const SQLite());
  getIt.registerLazySingleton<IUserRepository>(
    () => UserSQLiteRepository(getIt<SQLite>()),
  );
}
