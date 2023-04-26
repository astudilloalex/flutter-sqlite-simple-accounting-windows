import 'package:flutter/widgets.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/widgets/add_seat_description_input.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/widgets/add_seat_period_dropdown.dart';

class AddSeatForm extends StatefulWidget {
  const AddSeatForm({super.key});

  @override
  State<AddSeatForm> createState() => _AddSeatFormState();
}

class _AddSeatFormState extends State<AddSeatForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        children: [
          AddSeatPeriodDropdown(),
          AddSeatDescriptionInput(),
        ],
      ),
    );
  }
}
