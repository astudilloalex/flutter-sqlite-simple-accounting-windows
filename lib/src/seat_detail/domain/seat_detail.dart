import 'package:simple_accounting_offline/src/account/domain/account.dart';

class SeatDetail {
  const SeatDetail({
    this.account,
    required this.accountId,
    this.code = '',
    this.credit = 0.0,
    this.debit = 0.0,
    this.description,
    this.documentNumber,
    this.documentType,
    this.id,
    this.seatId = 0,
  });

  final Account? account;
  final int accountId;
  final String code;
  final double credit;
  final double debit;
  final String? description;
  final String? documentNumber;
  final String? documentType;
  final int? id;
  final int seatId;

  SeatDetail copyWith({
    int? accountId,
    String? code,
    double? credit,
    double? debit,
    String? description,
    String? documentNumber,
    String? documentType,
    int? id,
    int? seatId,
  }) {
    return SeatDetail(
      accountId: accountId ?? this.accountId,
      code: code ?? this.code,
      credit: credit ?? this.credit,
      debit: debit ?? this.debit,
      description: description ?? this.description,
      documentNumber: documentNumber ?? this.documentNumber,
      documentType: documentType ?? this.documentType,
      id: id ?? this.id,
      seatId: seatId ?? this.seatId,
    );
  }

  factory SeatDetail.fromSQLite(Map<String, Object?> map) {
    return SeatDetail(
      accountId: map['account_id']! as int,
      code: map['code']! as String,
      credit: double.parse(map['credit'].toString()),
      debit: double.parse(map['debit'].toString()),
      description: map['description'] as String?,
      documentNumber: map['document_number'] as String?,
      documentType: map['document_type'] as String?,
      id: map['id']! as int,
      seatId: map['seat_id']! as int,
    );
  }

  Map<String, Object?> toSQLite() {
    return {
      'account_id': accountId,
      'code': code,
      'credit': credit,
      'debit': debit,
      'description': description,
      'document_number': documentNumber,
      'document_type': documentType,
      'seat_id': seatId,
    };
  }
}
