import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:simple_accounting_offline/app/services/get_storage_service.dart';
import 'package:simple_accounting_offline/app/services/sqlite.dart';
import 'package:simple_accounting_offline/src/account/application/account_service.dart';
import 'package:simple_accounting_offline/src/account/domain/i_account_repository.dart';
import 'package:simple_accounting_offline/src/account/infrastructure/account_sqlite_repository.dart';
import 'package:simple_accounting_offline/src/account_category/application/account_category_service.dart';
import 'package:simple_accounting_offline/src/account_category/domain/i_account_category_repository.dart';
import 'package:simple_accounting_offline/src/account_category/infrastructure/account_category_sqlite_repository.dart';
import 'package:simple_accounting_offline/src/account_type/application/account_type_service.dart';
import 'package:simple_accounting_offline/src/account_type/domain/i_account_type_repository.dart';
import 'package:simple_accounting_offline/src/account_type/infrastructure/account_type_sqlite_repository.dart';
import 'package:simple_accounting_offline/src/accounting_period/application/accounting_period_service.dart';
import 'package:simple_accounting_offline/src/accounting_period/domain/i_accounting_period_repository.dart';
import 'package:simple_accounting_offline/src/accounting_period/infrastructure/accounting_period_sqlite_repository.dart';
import 'package:simple_accounting_offline/src/role/application/role_service.dart';
import 'package:simple_accounting_offline/src/role/domain/i_role_repository.dart';
import 'package:simple_accounting_offline/src/role/infrastructure/role_sqlite_repository.dart';
import 'package:simple_accounting_offline/src/seat/application/seat_service.dart';
import 'package:simple_accounting_offline/src/seat/domain/i_seat_repository.dart';
import 'package:simple_accounting_offline/src/seat/infrastructure/seat_sqlite_repository.dart';
import 'package:simple_accounting_offline/src/seat_detail/application/seat_detail_service.dart';
import 'package:simple_accounting_offline/src/seat_detail/domain/i_seat_detail_repository.dart';
import 'package:simple_accounting_offline/src/seat_detail/infrastructure/seat_detail_sqlite_repository.dart';
import 'package:simple_accounting_offline/src/user/application/user_service.dart';
import 'package:simple_accounting_offline/src/user/domain/i_user_repository.dart';
import 'package:simple_accounting_offline/src/user/infrastructure/user_sqlite_repository.dart';

GetIt getIt = GetIt.instance;

void setUpGetIt() {
  // Register singleton common services.
  getIt.registerSingleton<GetStorage>(GetStorage());
  getIt.registerSingleton<SQLite>(const SQLite());

  // Define repositories.
  getIt.registerLazySingleton<IAccountRepository>(
    () => AccountSQLiteRepository(getIt<SQLite>()),
  );
  getIt.registerLazySingleton<IAccountCategoryRepository>(
    () => AccountCategorySQLiteRepository(getIt<SQLite>()),
  );
  getIt.registerLazySingleton<IAccountTypeRepository>(
    () => AccountTypeSQLiteRepository(getIt<SQLite>()),
  );
  getIt.registerLazySingleton<IAccountingPeriodRepository>(
    () => AccountingPeriodSQLiteRepository(getIt<SQLite>()),
  );
  getIt.registerLazySingleton<IRoleRepository>(
    () => RoleSQLiteRepository(getIt<SQLite>()),
  );
  getIt.registerLazySingleton<ISeatRepository>(
    () => SeatSQLiteRepository(getIt<SQLite>()),
  );
  getIt.registerLazySingleton<ISeatDetailRepository>(
    () => SeatDetailSQLiteRepository(getIt<SQLite>()),
  );
  getIt.registerLazySingleton<IUserRepository>(
    () => UserSQLiteRepository(getIt<SQLite>()),
  );

  // Define custom services.
  getIt.registerLazySingleton<GetStorageService>(
    () => GetStorageService(getIt<GetStorage>()),
  );

  // Define services
  getIt.registerFactory<AccountService>(
    () => AccountService(
      getIt<IAccountRepository>(),
      getIt<GetStorageService>(),
    ),
  );
  getIt.registerFactory<AccountCategoryService>(
    () => AccountCategoryService(getIt<IAccountCategoryRepository>()),
  );
  getIt.registerFactory<AccountTypeService>(
    () => AccountTypeService(getIt<IAccountTypeRepository>()),
  );
  getIt.registerFactory<AccountingPeriodService>(
    () => AccountingPeriodService(
      getIt<IAccountingPeriodRepository>(),
      getIt<GetStorageService>(),
    ),
  );
  getIt.registerFactory<RoleService>(
    () => RoleService(getIt<IRoleRepository>()),
  );
  getIt.registerFactory<SeatService>(
    () => SeatService(
      getIt<ISeatRepository>(),
      getIt<ISeatDetailRepository>(),
      getIt<GetStorageService>(),
    ),
  );
  getIt.registerFactory<SeatDetailService>(
    () => SeatDetailService(
      getIt<ISeatDetailRepository>(),
      getIt<ISeatRepository>(),
    ),
  );
  getIt.registerFactory<UserService>(
    () => UserService(
      getIt<IUserRepository>(),
      getIt<GetStorageService>(),
    ),
  );
}
