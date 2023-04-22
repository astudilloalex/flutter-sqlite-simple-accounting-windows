class User {
  const User({
    this.active = true,
    this.code = '',
    required this.creationDate,
    this.id,
    required this.password,
    required this.roleId,
    required this.updateDate,
    required this.username,
  });

  final bool active;
  final String code;
  final DateTime creationDate;
  final int? id;
  final String password;
  final int roleId;
  final DateTime updateDate;
  final String username;

  User copyWith({
    bool? active,
    String? code,
    DateTime? creationDate,
    int? id,
    String? password,
    int? roleId,
    DateTime? updateDate,
    String? username,
  }) {
    return User(
      active: active ?? this.active,
      code: code ?? this.code,
      creationDate: creationDate ?? this.creationDate,
      id: id ?? this.id,
      password: password ?? this.password,
      roleId: roleId ?? this.roleId,
      updateDate: updateDate ?? this.updateDate,
      username: username ?? this.username,
    );
  }

  factory User.fromJson(Map<String, Object?> json) {
    return User(
      active: json['active']! as bool,
      code: json['code']! as String,
      creationDate: json['creation_date']! as DateTime,
      id: json['id']! as int,
      password: json['password']! as String,
      roleId: json['role_id']! as int,
      updateDate: json['update_date']! as DateTime,
      username: json['username']! as String,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'active': active,
      'code': code,
      'creation_date': creationDate,
      'password': password,
      'role_id': roleId,
      'update_date': updateDate,
      'username': username,
    };
  }
}
