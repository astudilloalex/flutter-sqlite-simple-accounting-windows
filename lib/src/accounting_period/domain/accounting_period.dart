class AccountingPeriod {
  const AccountingPeriod({
    this.active = true,
    this.code = '',
    required this.creationDate,
    required this.endDate,
    required this.name,
    this.id,
    required this.startDate,
    required this.updateDate,
    required this.userId,
  });

  final bool active;
  final String code;
  final DateTime creationDate;
  final DateTime endDate;
  final String name;
  final int? id;
  final DateTime startDate;
  final DateTime updateDate;
  final int userId;

  AccountingPeriod copyWith({
    bool? active,
    String? code,
    DateTime? creationDate,
    DateTime? endDate,
    String? name,
    int? id,
    DateTime? startDate,
    DateTime? updateDate,
    int? userId,
  }) {
    return AccountingPeriod(
      active: active ?? this.active,
      code: code ?? this.code,
      creationDate: creationDate ?? this.creationDate,
      endDate: endDate ?? this.endDate,
      name: name ?? this.name,
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      updateDate: updateDate ?? this.updateDate,
      userId: userId ?? this.userId,
    );
  }

  factory AccountingPeriod.fromSQLite(Map<String, Object?> map) {
    return AccountingPeriod(
      active: map['active'] == 1,
      code: map['code']! as String,
      creationDate: DateTime.parse(map['creation_date'].toString()),
      endDate: DateTime.parse(map['end_date'].toString()),
      name: map['name']! as String,
      id: map['id']! as int,
      startDate: DateTime.parse(map['start_date'].toString()),
      updateDate: DateTime.parse(map['update_date'].toString()),
      userId: map['user_id']! as int,
    );
  }

  Map<String, Object?> toSQLite() {
    return {
      'active': active ? 1 : 0,
      'code': code,
      'creation_date': creationDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'name': name,
      'start_date': startDate.toIso8601String(),
      'update_date': updateDate.toIso8601String(),
      'user_id': userId,
    };
  }
}
