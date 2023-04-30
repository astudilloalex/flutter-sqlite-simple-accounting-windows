import 'package:simple_accounting_offline/src/seat/domain/seat.dart';

class DetailState {
  const DetailState({
    required this.endDate,
    this.loading = false,
    this.seats = const [],
    required this.startDate,
  });

  final DateTime endDate;
  final bool loading;
  final List<Seat> seats;
  final DateTime startDate;

  DetailState copyWith({
    DateTime? endDate,
    bool? loading,
    List<Seat>? seats,
    DateTime? startDate,
  }) {
    return DetailState(
      endDate: endDate ?? this.endDate,
      loading: loading ?? this.loading,
      seats: seats ?? this.seats,
      startDate: startDate ?? this.startDate,
    );
  }
}
