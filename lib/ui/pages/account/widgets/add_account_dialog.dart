import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_accounting_offline/app/services/get_it_service.dart';
import 'package:simple_accounting_offline/src/account/application/account_service.dart';
import 'package:simple_accounting_offline/src/account/domain/account.dart';
import 'package:simple_accounting_offline/src/account_type/application/account_type_service.dart';
import 'package:simple_accounting_offline/src/account_type/domain/account_type.dart';

class AddAccountDialog extends StatefulWidget {
  const AddAccountDialog({
    super.key,
    this.account,
    required this.categoryId,
  });

  final Account? account;
  final int categoryId;

  @override
  State<AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool loading = true;
  String? codeErrorMessage;
  bool active = true;

  final List<AccountType> accountTypes = [];
  final List<Account> parentAccounts = [];

  int? selectedAccountTypeId;
  int? selectedAccountParentId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    codeController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450.0),
          child: loading
              ? const SizedBox(
                  width: 25.0,
                  height: 100.0,
                  child: Center(child: CircularProgressIndicator.adaptive()),
                )
              : Form(
                  key: formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      // Title
                      Text(
                        AppLocalizations.of(context)!.addAccount,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      const Divider(),
                      // Account type
                      DropdownButtonFormField<int?>(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        value: selectedAccountTypeId,
                        items: accountTypes.map((type) {
                          return DropdownMenuItem<int?>(
                            value: type.id,
                            child: Text(type.name),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.accountType,
                          hintText: AppLocalizations.of(context)!.select,
                        ),
                        focusColor: Colors.transparent,
                        onChanged: (value) {
                          setState(() {
                            selectedAccountTypeId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return AppLocalizations.of(context)!
                                .selectTypeAccount;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      // Parent account
                      DropdownButtonFormField<int?>(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        isExpanded: true,
                        value: selectedAccountParentId,
                        items: parentAccounts.map((type) {
                          return DropdownMenuItem<int?>(
                            value: type.id,
                            child: Text(type.name),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.parentAccount,
                          hintText: AppLocalizations.of(context)!.select,
                        ),
                        focusColor: Colors.transparent,
                        onChanged: (value) {
                          setState(() {
                            selectedAccountParentId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return AppLocalizations.of(context)!
                                .selectParentAccount;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      // Code input
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: codeController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.code,
                          errorText: codeErrorMessage,
                        ),
                        onChanged: (value) {
                          if (codeErrorMessage != null) {
                            setState(() {
                              codeErrorMessage = null;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      // Name input
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.name,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppLocalizations.of(context)!.invalidName;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      if (widget.account != null &&
                          widget.account!.accountTypeId == 2)
                        CheckboxListTile(
                          value: active,
                          title: Text(
                            active
                                ? AppLocalizations.of(context)!.active
                                : AppLocalizations.of(context)!.inactive,
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (value) {
                            setState(() => active = value ?? false);
                          },
                        ),
                      if (widget.account != null &&
                          widget.account!.accountTypeId == 2)
                        const SizedBox(height: 16.0),
                      // Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => context.pop(),
                            icon: const Icon(Icons.cancel_outlined),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            label: Text(AppLocalizations.of(context)!.cancel),
                          ),
                          const SizedBox(width: 10.0),
                          ElevatedButton.icon(
                            onPressed: _save,
                            icon: const Icon(Icons.save_outlined),
                            label: Text(AppLocalizations.of(context)!.save),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // Load the initial data.
  Future<void> _loadData() async {
    try {
      accountTypes.addAll(await getIt<AccountTypeService>().getAll());
      parentAccounts.addAll(
        await getIt<AccountService>().getAvailableParentsByCategory(
          widget.categoryId,
        ),
      );
      final Account? account = widget.account;
      if (account != null) {
        codeController.text = account.code;
        nameController.text = account.name;
        selectedAccountParentId = account.parentId;
        selectedAccountTypeId = account.accountTypeId;
        active = account.active;
      }
    } finally {
      loading = false;
      setState(() {});
    }
  }

  Future<void> _save() async {
    if (codeErrorMessage != null) {
      setState(() {
        codeErrorMessage = null;
      });
    }
    if (codeController.text.trim().isEmpty) {
      setState(() {
        codeErrorMessage = AppLocalizations.of(context)!.invalidCode;
      });
      return;
    }
    final Account? account = await getIt<AccountService>().getByCode(
      codeController.text,
    );
    if (account != null && account.code != widget.account?.code) {
      setState(() {
        codeErrorMessage = AppLocalizations.of(context)!.codeAlreadyExists;
      });
      return;
    }
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (context.mounted) {
      context.pop(
        Account(
          accountCategoryId: widget.categoryId,
          accountTypeId: selectedAccountTypeId ?? 0,
          active: active,
          code: codeController.text,
          creationDate: DateTime.now(),
          id: widget.account?.id,
          name: nameController.text,
          parentId: selectedAccountParentId,
          updateDate: DateTime.now(),
          userId: 0,
        ),
      );
    }
  }
}
