import 'package:equatable/equatable.dart';

/// User type enum
enum UserType {
  consumer,
  farmer,
  admin;

  static UserType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'FARMER':
      case 'PRODUCER':
        return UserType.farmer;
      case 'ADMIN':
        return UserType.admin;
      default:
        return UserType.consumer;
    }
  }

  String toApiString() {
    if (this == UserType.farmer) return 'PRODUCER';
    if (this == UserType.admin) return 'ADMIN';
    return 'CONSUMER';
  }
}

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? avatarUrl;
  final UserType userType;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.avatarUrl,
    this.userType = UserType.consumer,
    this.isVerified = false,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phoneNumber,
        avatarUrl,
        userType,
        isVerified,
        createdAt,
        updatedAt,
      ];

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    String? avatarUrl,
    UserType? userType,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      userType: userType ?? this.userType,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
