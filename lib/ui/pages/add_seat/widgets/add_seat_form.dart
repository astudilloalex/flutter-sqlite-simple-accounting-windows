import 'package:flutter/widgets.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/widgets/add_seat_date_input.dart';
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
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 655) {
                return Column(
                  children: [
                    const SizedBox(height: 4.0),
                    Row(
                      children: const [
                        Expanded(child: AddSeatDateInput()),
                        SizedBox(width: 20.0),
                        Expanded(child: AddSeatPeriodDropdown()),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    const AddSeatDescriptionInput()
                  ],
                );
              }
              return Column(
                children: const [
                  SizedBox(height: 4.0),
                  AddSeatDateInput(),
                  SizedBox(height: 20.0),
                  AddSeatPeriodDropdown(),
                  SizedBox(height: 20.0),
                  AddSeatDescriptionInput(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
