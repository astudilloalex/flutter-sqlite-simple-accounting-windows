import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_accounting_offline/app/app.dart';
import 'package:simple_accounting_offline/src/user/domain/user.dart';
import 'package:simple_accounting_offline/ui/pages/settings/cubit/settings_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/settings/cubit/settings_state.dart';
import 'package:simple_accounting_offline/ui/pages/settings/widgets/change_password_dialog.dart';

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
        if (user.id == 1) {
          return Tooltip(
            message: AppLocalizations.of(context)!.userCannotBeModified,
            child: AbsorbPointer(
              child: ListTile(
                tileColor: Colors.blueGrey.withOpacity(0.25),
                title: Text(user.username),
                subtitle: Text(
                  user.role?.name ?? '',
                ),
                leading: _ChangeUserStateSwitch(user),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.lock_outlined),
                  color: Colors.teal,
                ),
              ),
            ),
          );
        }
        return ListTile(
          title: Text(user.username),
          subtitle: Text(
            user.role?.name ?? '',
          ),
          leading: _ChangeUserStateSwitch(user),
          trailing: IconButton(
            onPressed: () => _changePassword(context, user),
            icon: const Icon(Icons.lock_outlined),
            color: Colors.teal,
          ),
        );
      },
    );
  }

  void _changePassword(BuildContext context, User user) {
    showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ChangePasswordDialog(user: user),
    ).then((value) async {
      if (value == null) return;
      final String? error =
          await context.read<SettingsCubit>().changeUserPassword(
                user.id!,
                value,
              );
      if (error != null && context.mounted) showErrorSnackbar(context, error);
    });
  }
}

class _ChangeUserStateSwitch extends StatefulWidget {
  const _ChangeUserStateSwitch(this.user);

  final User user;

  @override
  State<_ChangeUserStateSwitch> createState() => _ChangeUserStateSwitchState();
}

class _ChangeUserStateSwitchState extends State<_ChangeUserStateSwitch> {
  bool active = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() => active = widget.user.active);
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      inactiveTrackColor: Colors.blueGrey,
      activeColor: Colors.teal,
      value: active,
      onChanged: (value) async {
        await context.read<SettingsCubit>().changeUserState(active: value);
        setState(() => active = value);
      },
    );
  }
}
