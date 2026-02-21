class ContactModel {
  final int? id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String notes;
  final bool isFavorite;
  final DateTime createdAt;

  ContactModel({
    this.id,
    required this.name,
    required this.phone,
    this.email = '',
    this.address = '',
    this.notes = '',
    this.isFavorite = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  ContactModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? notes,
    bool? isFavorite,
    DateTime? createdAt,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'notes': notes,
      'is_favorite': isFavorite ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      phone: map['phone'] as String,
      email: (map['email'] as String?) ?? '',
      address: (map['address'] as String?) ?? '',
      notes: (map['notes'] as String?) ?? '',
      isFavorite: (map['is_favorite'] as int? ?? 0) == 1,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : DateTime.now(),
    );
  }

  String get displayName => name.trim().isEmpty ? phone : name;
}
