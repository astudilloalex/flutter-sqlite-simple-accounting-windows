import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_accounting_offline/app/services/get_it_service.dart';
import 'package:simple_accounting_offline/src/role/application/role_service.dart';
import 'package:simple_accounting_offline/src/role/domain/role.dart';
import 'package:simple_accounting_offline/src/user/domain/user.dart';

class AddEditUserDialog extends StatefulWidget {
  const AddEditUserDialog({super.key});

  @override
  State<AddEditUserDialog> createState() => _AddEditUserDialogState();
}

class _AddEditUserDialogState extends State<AddEditUserDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final List<Role> roles = [];
  int? selectedRoleId;
  bool viewPassword = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                AppLocalizations.of(context)!.addUser,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const Divider(height: 20.0),
              Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<int?>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      value: selectedRoleId,
                      items: roles.map((role) {
                        return DropdownMenuItem<int?>(
                          value: role.id,
                          child: Text(role.name),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.role,
                        hintText: AppLocalizations.of(context)!.selectARole,
                      ),
                      onChanged: (value) {
                        selectedRoleId = value;
                      },
                      validator: (value) {
                        if (value == null) {
                          return AppLocalizations.of(context)!.selectARole;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.username,
                      ),
                      validator: (value) {
                        if (value == null || value.length < 4) {
                          return AppLocalizations.of(context)!.min4Characters;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.password,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() => viewPassword = !viewPassword);
                          },
                          icon: Icon(
                            viewPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return AppLocalizations.of(context)!.min6Characters;
                        }
                        return null;
                      },
                      obscureText: !viewPassword,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    icon: const Icon(Icons.cancel_outlined),
                    label: Text(AppLocalizations.of(context)!.cancel),
                  ),
                  const SizedBox(width: 20.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      context.pop(
                        User(
                          creationDate: DateTime.now(),
                          password: passwordController.text.trim(),
                          roleId: selectedRoleId!,
                          updateDate: DateTime.now(),
                          username: usernameController.text.trim(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.save_outlined),
                    label: Text(AppLocalizations.of(context)!.save),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _load() async {
    roles.addAll(await getIt<RoleService>().getAll());
    setState(() {});
  }
}
