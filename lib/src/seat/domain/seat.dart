class Seat {
  const Seat({
    this.cancelled = false,
    this.code = '',
    required this.date,
    this.description,
    this.id,
    required this.periodId,
    this.userId = 0,
  });

  final bool cancelled;
  final String code;
  final DateTime date;
  final String? description;
  final int? id;
  final int periodId;
  final int userId;

  Seat copyWith({
    bool? cancelled,
    String? code,
    DateTime? date,
    String? description,
    int? id,
    int? periodId,
    int? userId,
  }) {
    return Seat(
      cancelled: cancelled ?? this.cancelled,
      code: code ?? this.code,
      date: date ?? this.date,
      description: description ?? this.description,
      id: id ?? this.id,
      periodId: periodId ?? this.periodId,
      userId: userId ?? this.userId,
    );
  }

  factory Seat.fromSQLite(Map<String, Object?> map) {
    return Seat(
      cancelled: map['canceled'] == 1,
      code: map['code']! as String,
      date: DateTime.parse(map['date'].toString()),
      description: map['description'] as String?,
      id: map['id']! as int,
      periodId: map['period_id']! as int,
      userId: map['user_id']! as int,
    );
  }

  Map<String, Object?> toSQLite() {
    return {
      'canceled': cancelled ? 1 : 0,
      'code': code,
      'date': date.toIso8601String(),
      'description': description,
      'period_id': periodId,
      'user_id': userId,
    };
  }
}
