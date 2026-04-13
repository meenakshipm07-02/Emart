class ProfileModel {
  final String status;
  final ProfileData? profile;

  ProfileModel({required this.status, this.profile});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      status: json['status'] ?? '',
      profile: json['profile'] != null
          ? ProfileData.fromJson(json['profile'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'profile': profile?.toJson(),
  };
}

class ProfileData {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String createdAt;

  ProfileData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'created_at': createdAt,
  };
}
