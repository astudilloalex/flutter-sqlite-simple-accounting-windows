class Account {
  const Account({
    required this.accountCategoryId,
    required this.accountTypeId,
    this.active = true,
    this.code = '',
    required this.creationDate,
    this.description,
    this.id,
    required this.name,
    this.parentId,
    required this.updateDate,
    required this.userId,
  });

  final int accountCategoryId;
  final int accountTypeId;
  final bool active;
  final String code;
  final DateTime creationDate;
  final String? description;
  final int? id;
  final String name;
  final int? parentId;
  final DateTime updateDate;
  final int userId;

  Account copyWith({
    int? accountCategoryId,
    int? accountTypeId,
    bool? active,
    String? code,
    DateTime? creationDate,
    String? description,
    int? id,
    String? name,
    int? parentId,
    DateTime? updateDate,
    int? userId,
  }) {
    return Account(
      accountCategoryId: accountCategoryId ?? this.accountCategoryId,
      accountTypeId: accountTypeId ?? this.accountTypeId,
      active: active ?? this.active,
      code: code ?? this.code,
      creationDate: creationDate ?? this.creationDate,
      description: description ?? this.description,
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      updateDate: updateDate ?? this.updateDate,
      userId: userId ?? this.userId,
    );
  }

  factory Account.fromJson(Map<String, Object?> json) {
    return Account(
      accountCategoryId: json['account_category_id']! as int,
      accountTypeId: json['account_type_id']! as int,
      active: json['active'] == 1,
      code: json['code']! as String,
      creationDate: DateTime.parse(json['creation_date'].toString()),
      description: json['description'] as String?,
      id: json['id']! as int,
      name: json['name']! as String,
      parentId: json['parent_id'] as int?,
      updateDate: DateTime.parse(json['update_date'].toString()),
      userId: json['user_id']! as int,
    );
  }

  Map<String, Object?> toSQLite() {
    return {
      'account_category_id': accountCategoryId,
      'account_type_id': accountTypeId,
      'active': active ? 1 : 0,
      'code': code,
      'creation_date': creationDate.toIso8601String(),
      'description': description,
      'name': name,
      'parent_id': parentId,
      'update_date': updateDate.toIso8601String(),
      'user_id': userId,
    };
  }
}
