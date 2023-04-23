import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_accounting_offline/app/app.dart';
import 'package:simple_accounting_offline/src/account/domain/account.dart';
import 'package:simple_accounting_offline/ui/pages/account/cubit/account_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/account/cubit/account_state.dart';
import 'package:simple_accounting_offline/ui/pages/account/widgets/add_account_dialog.dart';

class AccountList extends StatelessWidget {
  const AccountList({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountState state = context.watch<AccountCubit>().state;
    return state.loading
        ? const Center(child: CircularProgressIndicator.adaptive())
        : ListView.separated(
            separatorBuilder: (context, index) => const Divider(height: 1.0),
            itemCount: state.accounts.length,
            itemBuilder: (context, index) {
              final Account account = state.accounts[index];
              return Container(
                color: account.accountTypeId == 1
                    ? Colors.blue.withOpacity(0.05)
                    : null,
                child: ListTile(
                  leading: account.active
                      ? const Icon(
                          Icons.check_circle_outlined,
                          color: Colors.teal,
                        )
                      : const Icon(Icons.remove_circle_outlined),
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
                    onPressed: () {
                      showDialog<Account?>(
                        context: context,
                        builder: (_) => AddAccountDialog(
                          categoryId: account.accountCategoryId,
                          account: account,
                        ),
                      ).then((value) => _onUpdate(value, context));
                    },
                  ),
                ),
              );
            },
          );
  }

  Future<void> _onUpdate(Account? account, BuildContext context) async {
    if (account == null) return;
    final String? error =
        await context.read<AccountCubit>().updateAccount(account);
    if (context.mounted) {
      if (error != null) {
        showErrorSnackbar(context, error);
      }
    }
  }
}
