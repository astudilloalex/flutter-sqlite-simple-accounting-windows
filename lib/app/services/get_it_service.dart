import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:simple_accounting_offline/app/services/get_storage_service.dart';
import 'package:simple_accounting_offline/app/services/sqlite.dart';
import 'package:simple_accounting_offline/src/account_category/application/account_category_service.dart';
import 'package:simple_accounting_offline/src/account_category/domain/i_account_category_repository.dart';
import 'package:simple_accounting_offline/src/account_category/infrastructure/account_category_sqlite_repository.dart';
import 'package:simple_accounting_offline/src/account_type/application/account_type_service.dart';
import 'package:simple_accounting_offline/src/account_type/domain/i_account_type_repository.dart';
import 'package:simple_accounting_offline/src/account_type/infrastructure/account_type_sqlite_repository.dart';
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
  getIt.registerLazySingleton<IAccountTypeRepository>(
    () => AccountTypeSQLiteRepository(getIt<SQLite>()),
  );
  getIt.registerLazySingleton<IAccountTypeRepository>(
    () => AccountTypeSQLiteRepository(getIt<SQLite>()),
  );
  getIt.registerLazySingleton<IAccountCategoryRepository>(
    () => AccountCategorySQLiteRepository(getIt<SQLite>()),
  );

  // Define custom services.
  getIt.registerFactory<GetStorageService>(
    () => GetStorageService(getIt<GetStorage>()),
  );

  // Define services
  getIt.registerFactory<UserService>(
    () => UserService(getIt<IUserRepository>()),
  );
  getIt.registerFactory<AccountTypeService>(
    () => AccountTypeService(getIt<IAccountTypeRepository>()),
  );
  getIt.registerFactory<AccountCategoryService>(
    () => AccountCategoryService(getIt<IAccountCategoryRepository>()),
  );
}
