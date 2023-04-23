class AccountCategory {
  const AccountCategory({
    this.active = true,
    this.code = '',
    required this.creationDate,
    this.description,
    this.id,
    required this.name,
    required this.updateDate,
  });

  final bool active;
  final String code;
  final DateTime creationDate;
  final String? description;
  final int? id;
  final String name;
  final DateTime updateDate;

  factory AccountCategory.fromJson(Map<String, Object?> json) {
    return AccountCategory(
      active: json['active'] == 1,
      code: json['code']! as String,
      creationDate: DateTime.parse(json['creation_date'].toString()),
      description: json['description'] as String?,
      id: json['id']! as int,
      name: json['name']! as String,
      updateDate: DateTime.parse(json['update_date'].toString()),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'active': active,
      'code': code,
      'creation_date': creationDate.toIso8601String(),
      'name': name,
      'description': description,
      'update_date': updateDate.toIso8601String(),
    };
  }
}
