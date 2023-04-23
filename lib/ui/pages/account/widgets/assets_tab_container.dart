import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_accounting_offline/src/account/domain/account.dart';
import 'package:simple_accounting_offline/ui/pages/account/cubit/assets_account_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/account/cubit/assets_account_state.dart';

class AssetsTabContainer extends StatelessWidget {
  const AssetsTabContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final AssetsAccountState state = context.watch<AssetsAccountCubit>().state;
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: state.accounts.length,
      itemBuilder: (context, index) {
        final Account account = state.accounts[index];
        return ListTile(
          title: Text(
            '${account.code}  ${account.name}',
            style: TextStyle(
              fontWeight: account.accountTypeId == 1
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {},
          ),
        );
      },
    );
  }
}
