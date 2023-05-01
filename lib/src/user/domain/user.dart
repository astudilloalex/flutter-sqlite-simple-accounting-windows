import 'package:simple_accounting_offline/src/role/domain/role.dart';

class User {
  const User({
    this.active = true,
    this.code = '',
    required this.creationDate,
    this.id,
    required this.password,
    this.role,
    required this.roleId,
    required this.updateDate,
    required this.username,
  });

  final bool active;
  final String code;
  final DateTime creationDate;
  final int? id;
  final String password;
  final Role? role;
  final int roleId;
  final DateTime updateDate;
  final String username;

  User copyWith({
    bool? active,
    String? code,
    DateTime? creationDate,
    int? id,
    String? password,
    Role? role,
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
      role: role ?? this.role,
      roleId: roleId ?? this.roleId,
      updateDate: updateDate ?? this.updateDate,
      username: username ?? this.username,
    );
  }

  factory User.fromJson(Map<String, Object?> json) {
    return User(
      active: json['active'] == 1,
      code: json['code']! as String,
      creationDate: DateTime.parse(json['creation_date'].toString()),
      id: json['id']! as int,
      password: json['password']! as String,
      roleId: json['role_id']! as int,
      updateDate: DateTime.parse(json['update_date'].toString()),
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
