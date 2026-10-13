class TrustedContact {
  final String id;
  final String userId;
  final String name;
  final String phoneNumber;
  final bool isActive;

  const TrustedContact({
    required this.id,
    required this.userId,
    required this.name,
    required this.phoneNumber,
    this.isActive = true,
  });

  factory TrustedContact.fromJson(Map<String, dynamic> json) {
    return TrustedContact(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'phone_number': phoneNumber,
      'is_active': isActive,
    };
  }
}
