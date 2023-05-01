import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:simple_accounting_offline/src/user/domain/user.dart';
import 'package:simple_accounting_offline/ui/pages/settings/cubit/settings_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/settings/cubit/settings_state.dart';

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsState state = context.watch<SettingsCubit>().state;
    if (state.loading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
    return ListView.builder(
      itemCount: state.users.length,
      itemBuilder: (context, index) {
        final User user = state.users[index];
        return ListTile(
          title: Text(user.username),
          subtitle: Text(
            'Created At: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(user.creationDate)}',
          ),
        );
      },
    );
  }
}
