class AddSeatFormState {
  const AddSeatFormState({
    required this.date,
    this.selectedPeriodId,
  });

  final DateTime date;
  final int? selectedPeriodId;

  AddSeatFormState copyWith({
    DateTime? date,
    int? selectedPeriodId,
  }) {
    return AddSeatFormState(
      date: date ?? this.date,
      selectedPeriodId: selectedPeriodId ?? this.selectedPeriodId,
    );
  }
}
