import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:simple_accounting_offline/ui/pages/detail/cubit/detail_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/detail/cubit/detail_state.dart';

class SeatTab extends StatelessWidget {
  const SeatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final DetailState state = context.watch<DetailCubit>().state;
    if (state.loading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: state.seats.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {},
          leading: Switch(
            value: !state.seats[index].cancelled,
            onChanged: (value) {
              context.read<DetailCubit>().changeState(
                    state.seats[index].id!,
                    cancelled: !value,
                  );
            },
            inactiveTrackColor: Colors.blueGrey,
            activeColor: Colors.teal,
          ),
          title: Text(
            DateFormat('EEE, MMM dd, yyyy HH:mm').format(
              state.seats[index].date,
            ),
          ),
          subtitle: Text(state.seats[index].description ?? ''),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(state.seats[index].total.toStringAsFixed(2)),
              const SizedBox(width: 20.0),
              const Icon(Icons.arrow_forward_ios_outlined),
            ],
          ),
        );
      },
    );
  }
}
