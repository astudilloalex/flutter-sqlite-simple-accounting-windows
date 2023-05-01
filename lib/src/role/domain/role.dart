class Role {
  const Role({
    this.active = false,
    this.code = '',
    required this.creationDate,
    this.id = 0,
    this.name = '',
    required this.updateDate,
  });

  final bool active;
  final String code;
  final DateTime creationDate;
  final int id;
  final String name;
  final DateTime updateDate;

  Role copyWith({
    bool? active,
    String? code,
    DateTime? creationDate,
    int? id,
    String? name,
    DateTime? updateDate,
  }) {
    return Role(
      active: active ?? this.active,
      code: code ?? this.code,
      creationDate: creationDate ?? this.creationDate,
      id: id ?? this.id,
      name: name ?? this.name,
      updateDate: updateDate ?? this.updateDate,
    );
  }

  factory Role.fromSQLite(Map<String, Object?> map) {
    return Role(
      active: map['active'] == 1,
      code: map['code']! as String,
      creationDate: DateTime.parse(map['creation_date'].toString()),
      id: map['id']! as int,
      name: map['name']! as String,
      updateDate: DateTime.parse(map['update_date'].toString()),
    );
  }

  Map<String, Object?> toSQLite() {
    return {
      'active': active ? 1 : 0,
      'code': code,
      'creation_date': creationDate.toIso8601String(),
      'name': name,
      'update_date': updateDate.toIso8601String(),
    };
  }
}
