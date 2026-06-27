import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'auth_response_model.g.dart';

/// Model for auth API response wrapper
@JsonSerializable()
class AuthApiResponse {
  final String status;
  final AuthResponseModel? data;
  final String? message;

  AuthApiResponse({
    required this.status,
    this.data,
    this.message,
  });

  factory AuthApiResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthApiResponseToJson(this);

  bool get isSuccess => status == 'success';
}

/// Model for auth data (login/register response)
@JsonSerializable()
class AuthResponseModel {
  final UserModel user;
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  @JsonKey(name: 'token_type')
  final String? tokenType;
  @JsonKey(name: 'expires_in')
  final int? expiresIn;

  AuthResponseModel({
    required this.user,
    required this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);

  /// Calculate token expiry time
  DateTime get tokenExpiryTime {
    final expirySeconds = expiresIn ?? 3600; // Default 1 hour
    return DateTime.now().add(Duration(seconds: expirySeconds));
  }
}

/// Model for token refresh response
@JsonSerializable()
class TokenRefreshResponse {
  final String status;
  final TokenRefreshData? data;
  final String? message;

  TokenRefreshResponse({
    required this.status,
    this.data,
    this.message,
  });

  factory TokenRefreshResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenRefreshResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TokenRefreshResponseToJson(this);

  bool get isSuccess => status == 'success';
}

@JsonSerializable()
class TokenRefreshData {
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  @JsonKey(name: 'token_type')
  final String? tokenType;
  @JsonKey(name: 'expires_in')
  final int? expiresIn;

  TokenRefreshData({
    required this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
  });

  factory TokenRefreshData.fromJson(Map<String, dynamic> json) =>
      _$TokenRefreshDataFromJson(json);

  Map<String, dynamic> toJson() => _$TokenRefreshDataToJson(this);

  DateTime get tokenExpiryTime {
    final expirySeconds = expiresIn ?? 3600;
    return DateTime.now().add(Duration(seconds: expirySeconds));
  }
}

/// Model for user info response (/auth/me)
@JsonSerializable()
class UserInfoResponse {
  final String status;
  final UserModel? data;
  final String? message;

  UserInfoResponse({
    required this.status,
    this.data,
    this.message,
  });

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$UserInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoResponseToJson(this);

  bool get isSuccess => status == 'success';
}

/// Model for simple API response (logout, etc.)
@JsonSerializable()
class SimpleApiResponse {
  final String status;
  final String? message;

  SimpleApiResponse({
    required this.status,
    this.message,
  });

  factory SimpleApiResponse.fromJson(Map<String, dynamic> json) =>
      _$SimpleApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SimpleApiResponseToJson(this);

  bool get isSuccess => status == 'success';
}
