import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_accounting_offline/app/services/get_it_service.dart';
import 'package:simple_accounting_offline/app/services/sqlite.dart';
import 'package:simple_accounting_offline/src/account/application/account_service.dart';
import 'package:simple_accounting_offline/src/account/domain/account.dart';
import 'package:simple_accounting_offline/src/seat_detail/domain/seat_detail.dart';
import 'package:simple_accounting_offline/ui/widgets/account_search_delegate.dart';

class AddSeatDetailDialog extends StatelessWidget {
  const AddSeatDetailDialog({
    super.key,
    this.seatDetail,
  });

  final SeatDetail? seatDetail;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650.0, maxHeight: 625.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.add,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const Divider(),
              Expanded(child: _Form(seatDetail: seatDetail)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({
    this.seatDetail,
  });

  final SeatDetail? seatDetail;

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController documentController = TextEditingController();
  final TextEditingController documentTypeController = TextEditingController();
  final TextEditingController creditController = TextEditingController();
  final TextEditingController debitController = TextEditingController();

  Account? selectedAccount;
  String? accountError;

  @override
  void initState() {
    super.initState();
    creditController.addListener(() {
      if (creditController.text.trim().isNotEmpty) {
        debitController.text = '';
      }
    });
    debitController.addListener(() {
      if (debitController.text.trim().isNotEmpty) {
        creditController.text = '';
      }
    });
    _loadData();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    documentController.dispose();
    documentTypeController.dispose();
    creditController.dispose();
    debitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        children: [
          // Account
          ListTile(
            onTap: () async {
              showSearch<Account?>(
                context: context,
                delegate: AccountSearchDelegate(
                  data: await getIt<AccountService>().getMovementAccounts(),
                ),
              ).then((value) {
                if (value != null) {
                  setState(() {
                    selectedAccount = value;
                    accountError = null;
                  });
                }
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(
                color: accountError == null ? Colors.teal : Colors.redAccent,
              ),
            ),
            title: selectedAccount == null
                ? Text(AppLocalizations.of(context)!.account)
                : Text(selectedAccount!.name),
            trailing:
                selectedAccount == null ? null : Text(selectedAccount!.code),
          ),
          if (accountError != null)
            Text(
              accountError!,
              style: const TextStyle(
                color: Colors.redAccent,
              ),
            ),
          const SizedBox(height: 20.0),
          TextFormField(
            controller: descriptionController,
            minLines: 3,
            maxLines: 5,
            maxLength: 300,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.description,
            ),
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            controller: documentTypeController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.documentType,
            ),
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            controller: documentController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.documentNumber,
            ),
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            controller: debitController,
            autovalidateMode: AutovalidateMode.always,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.debit,
            ),
            validator: (value) {
              if ((value == null || value.trim().isEmpty) &&
                  creditController.text.trim().isEmpty) {
                return AppLocalizations.of(context)!.invalidValue;
              }
              return null;
            },
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            controller: creditController,
            autovalidateMode: AutovalidateMode.always,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.credit,
            ),
            validator: (value) {
              if ((value == null || value.trim().isEmpty) &&
                  debitController.text.trim().isEmpty) {
                return AppLocalizations.of(context)!.invalidValue;
              }
              return null;
            },
          ),
          const SizedBox(height: 20.0),
          // Action buttons.
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
                onPressed: _save,
                icon: const Icon(Icons.save_outlined),
                label: Text(AppLocalizations.of(context)!.save),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _loadData() async {
    if (widget.seatDetail == null) return;
    final Account? finded = await getIt<AccountService>().getById(
      widget.seatDetail!.accountId,
    );
    setState(() => selectedAccount = finded);
    descriptionController.text = widget.seatDetail!.description ?? '';
    documentController.text = widget.seatDetail!.documentNumber ?? '';
    documentTypeController.text = widget.seatDetail!.documentType ?? '';
    final Decimal credit = Decimal.parse(
      widget.seatDetail!.credit.toString(),
    );
    final Decimal debit = Decimal.parse(
      widget.seatDetail!.debit.toString(),
    );
    creditController.text =
        credit.compareTo(Decimal.zero) == 0 ? '' : credit.toString();
    debitController.text =
        debit.compareTo(Decimal.zero) == 0 ? '' : debit.toString();
  }

  void _save() {
    if (!formKey.currentState!.validate()) return;
    if (selectedAccount == null) {
      setState(() {
        accountError = AppLocalizations.of(context)!.selectAnAccount;
      });
      return;
    }
    final Decimal? credit = Decimal.tryParse(creditController.text.trim());
    final Decimal? debit = Decimal.tryParse(debitController.text.trim());
    context.pop(
      SeatDetail(
        account: selectedAccount,
        accountId: selectedAccount?.id ?? 0,
        code: widget.seatDetail?.code ?? generateSQLiteCode(),
        credit: credit == null ? 0.0 : credit.toDouble(),
        debit: debit == null ? 0.0 : debit.toDouble(),
        description: descriptionController.text.trim().toUpperCase(),
        documentNumber: documentController.text.trim().toUpperCase(),
        documentType: documentController.text.trim().toUpperCase(),
        id: widget.seatDetail?.id,
        seatId: widget.seatDetail?.seatId ?? 0,
      ),
    );
  }
}
