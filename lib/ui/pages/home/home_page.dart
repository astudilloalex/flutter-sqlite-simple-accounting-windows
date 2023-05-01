import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_accounting_offline/app/app.dart';
import 'package:simple_accounting_offline/app/services/get_it_service.dart';
import 'package:simple_accounting_offline/app/services/get_storage_service.dart';
import 'package:simple_accounting_offline/src/account/application/account_service.dart';
import 'package:simple_accounting_offline/src/accounting_period/application/accounting_period_service.dart';
import 'package:simple_accounting_offline/src/role/application/role_service.dart';
import 'package:simple_accounting_offline/src/seat/application/seat_service.dart';
import 'package:simple_accounting_offline/src/seat_detail/application/seat_detail_service.dart';
import 'package:simple_accounting_offline/src/user/application/user_service.dart';
import 'package:simple_accounting_offline/ui/pages/account/account_page.dart';
import 'package:simple_accounting_offline/ui/pages/account/cubit/account_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/add_seat_page.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/cubit/add_seat_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/dashboard/cubit/dashboard_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/dashboard/dashboard_page.dart';
import 'package:simple_accounting_offline/ui/pages/detail/cubit/detail_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/detail/detail_page.dart';
import 'package:simple_accounting_offline/ui/pages/home/cubit/home_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/home/widgets/change_password_dialog.dart';
import 'package:simple_accounting_offline/ui/pages/settings/cubit/settings_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/settings/settings_page.dart';
import 'package:simple_accounting_offline/ui/routes/route_name.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Available widgets for rail.
    final List<Widget> widgets = <Widget>[
      if (context.read<HomeCubit>().roleId == 1)
        BlocProvider(
          create: (context) => DashboardCubit(
            getIt<SeatService>(),
            getIt<SeatDetailService>(),
          )..load(),
          child: const DashboardPage(),
        ),
      if (context.read<HomeCubit>().roleId == 1 ||
          context.read<HomeCubit>().roleId == 2)
        BlocProvider(
          create: (context) => DetailCubit(
            getIt<SeatService>(),
            getIt<SeatDetailService>(),
          )..load(),
          child: const DetailPage(),
        ),
      if (context.read<HomeCubit>().roleId == 1 ||
          context.read<HomeCubit>().roleId == 3)
        BlocProvider(
          create: (context) => AddSeatCubit(
            getIt<AccountingPeriodService>(),
            getIt<AccountService>(),
            getIt<SeatService>(),
          )..load(),
          child: const AddSeatPage(),
        ),
      if (context.read<HomeCubit>().roleId == 1)
        BlocProvider(
          create: (context) => AccountCubit(
            getIt<AccountService>(),
          )..loadAccounts(1),
          child: const AccountPage(),
        ),
      if (context.read<HomeCubit>().roleId == 1 ||
          context.read<HomeCubit>().roleId == 3)
        BlocProvider(
          create: (context) => SettingsCubit(
            getIt<AccountingPeriodService>(),
            getIt<RoleService>(),
            getIt<UserService>(),
          )..load(),
          child: const SettingsPage(),
        ),
    ];
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80.0,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                context.read<HomeCubit>().changeExpandedRail();
              },
              icon: Icon(
                context.watch<HomeCubit>().state.extendedRail
                    ? Icons.menu_open_outlined
                    : Icons.menu_outlined,
              ),
            ),
          ],
        ),
        title: ElevatedButton.icon(
          onPressed: () {
            context.read<HomeCubit>().changeCurrentIndex(2);
          },
          label: Text(AppLocalizations.of(context)!.addMovement),
          icon: const Icon(Icons.add_outlined),
        ),
        actions: [
          PopupMenuButton<int>(
            onSelected: (value) {
              switch (value) {
                case 0:
                  _changePassword(context);
                  break;
                default:
                  context.read<HomeCubit>().logout();
                  context.goNamed(RouteName.signIn);
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text(AppLocalizations.of(context)!.changePassword),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text(AppLocalizations.of(context)!.logout),
                ),
              ];
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_outlined),
                  const SizedBox(width: 10.0),
                  Text(
                    getIt<GetStorageService>().currentUsername ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            extended: context.watch<HomeCubit>().state.extendedRail,
            destinations: [
              if (context.read<HomeCubit>().roleId == 1)
                NavigationRailDestination(
                  icon: const Icon(Icons.dashboard_outlined),
                  label: Text(AppLocalizations.of(context)!.dashboard),
                ),
              if (context.read<HomeCubit>().roleId == 1 ||
                  context.read<HomeCubit>().roleId == 2)
                NavigationRailDestination(
                  icon: const Icon(Icons.wallet_outlined),
                  label: Text(AppLocalizations.of(context)!.details),
                ),
              NavigationRailDestination(
                icon: const Icon(Icons.add_circle_outlined),
                label: Text(AppLocalizations.of(context)!.add),
              ),
              if (context.read<HomeCubit>().roleId == 1)
                NavigationRailDestination(
                  icon: const Icon(Icons.account_balance_outlined),
                  label: Text(AppLocalizations.of(context)!.accounts),
                ),
              if (context.read<HomeCubit>().roleId == 1 ||
                  context.read<HomeCubit>().roleId == 3)
                NavigationRailDestination(
                  icon: const Icon(Icons.settings_outlined),
                  label: Text(AppLocalizations.of(context)!.settings),
                ),
            ],
            onDestinationSelected: (value) {
              context.read<HomeCubit>().changeCurrentIndex(value);
            },
            selectedIndex: context.watch<HomeCubit>().state.currentIndex,
            // labelType: context.watch<HomeCubit>().state.extendedRail
            //     ? null
            //     : NavigationRailLabelType.selected,
            minExtendedWidth: 200.0,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: widgets[context.watch<HomeCubit>().state.currentIndex],
          ),
        ],
      ),
    );
  }

  Future<void> _changePassword(BuildContext context) async {
    showDialog<List<String>?>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const ChangePasswordDialog(),
    ).then((value) async {
      if (value == null) return;
      final String? error =
          await context.read<HomeCubit>().changePassword(value);
      if (error != null && context.mounted) showErrorSnackbar(context, error);
    });
  }
}
