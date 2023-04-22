abstract class UnauthorizedException implements Exception {
  const UnauthorizedException([this.message]);
  final String? message;
}

class BadCredentialException extends UnauthorizedException {
  const BadCredentialException([super.message]);
}

class AccountException extends UnauthorizedException {
  const AccountException([super.message]);
}
