class SignInState {
  const SignInState({
    this.loading = false,
    this.remember = false,
    this.viewPassword = false,
  });

  final bool loading;
  final bool remember;
  final bool viewPassword;

  SignInState copyWith({
    bool? loading,
    bool? remember,
    bool? viewPassword,
  }) {
    return SignInState(
      loading: loading ?? this.loading,
      remember: remember ?? this.remember,
      viewPassword: viewPassword ?? this.viewPassword,
    );
  }
}
