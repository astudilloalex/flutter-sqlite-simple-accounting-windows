abstract class UnauthorizedException implements Exception {
  const UnauthorizedException([this.code]);
  final String? code;
}

class BadCredentialException extends UnauthorizedException {
  const BadCredentialException([super.code]);
}

class AccountException extends UnauthorizedException {
  const AccountException([super.code]);
}
