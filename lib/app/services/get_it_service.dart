import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:simple_accounting_offline/app/services/get_storage_service.dart';
import 'package:simple_accounting_offline/app/services/sqlite.dart';
import 'package:simple_accounting_offline/src/user/application/user_service.dart';
import 'package:simple_accounting_offline/src/user/domain/i_user_repository.dart';
import 'package:simple_accounting_offline/src/user/infrastructure/user_sqlite_repository.dart';

GetIt getIt = GetIt.instance;

void setUpGetIt() {
  // Register singleton common services.
  getIt.registerSingleton<GetStorage>(GetStorage());
  getIt.registerSingleton<SQLite>(const SQLite());

  // Define repositories.
  getIt.registerLazySingleton<IUserRepository>(
    () => UserSQLiteRepository(getIt<SQLite>()),
  );

  // Define services.
  getIt.registerFactory<GetStorageService>(
    () => GetStorageService(getIt<GetStorage>()),
  );

  getIt.registerFactory<UserService>(
    () => UserService(getIt<IUserRepository>()),
  );
}
