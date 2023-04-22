class HomeState {
  const HomeState({
    this.currentIndex = 0,
    this.loading = false,
    this.extendedRail = false,
  });

  final int currentIndex;
  final bool loading;
  final bool extendedRail;

  HomeState copyWith({
    int? currentIndex,
    bool? loading,
    bool? extendedRail,
  }) {
    return HomeState(
      currentIndex: currentIndex ?? this.currentIndex,
      loading: loading ?? this.loading,
      extendedRail: extendedRail ?? this.extendedRail,
    );
  }
}
