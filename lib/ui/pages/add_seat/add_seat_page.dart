import 'package:flutter/material.dart';
import 'package:simple_accounting_offline/ui/pages/add_seat/widgets/add_seat_form.dart';

class AddSeatPage extends StatelessWidget {
  const AddSeatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AddSeatForm(),
    );
  }
}
