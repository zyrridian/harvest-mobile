import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/share_content.dart';

part 'share_content_model.g.dart';

@JsonSerializable()
class PlatformSpecificUrlsModel {
  final String whatsapp;
  final String facebook;
  final String twitter;
  final String instagram;

  const PlatformSpecificUrlsModel({
    required this.whatsapp,
    required this.facebook,
    required this.twitter,
    required this.instagram,
  });

  factory PlatformSpecificUrlsModel.fromJson(Map<String, dynamic> json) =>
      _$PlatformSpecificUrlsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlatformSpecificUrlsModelToJson(this);

  PlatformSpecificUrls toEntity() {
    return PlatformSpecificUrls(
      whatsapp: whatsapp,
      facebook: facebook,
      twitter: twitter,
      instagram: instagram,
    );
  }
}

@JsonSerializable()
class ShareContentModel {
  @JsonKey(name: 'share_url')
  final String shareUrl;
  @JsonKey(name: 'short_url')
  final String shortUrl;
  @JsonKey(name: 'deep_link')
  final String deepLink;
  @JsonKey(name: 'share_text')
  final String shareText;
  @JsonKey(name: 'platform_specific')
  final PlatformSpecificUrlsModel platformSpecific;
  @JsonKey(name: 'qr_code')
  final String qrCode;
  @JsonKey(name: 'generated_at')
  final String generatedAt;

  const ShareContentModel({
    required this.shareUrl,
    required this.shortUrl,
    required this.deepLink,
    required this.shareText,
    required this.platformSpecific,
    required this.qrCode,
    required this.generatedAt,
  });

  factory ShareContentModel.fromJson(Map<String, dynamic> json) =>
      _$ShareContentModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShareContentModelToJson(this);

  ShareContent toEntity() {
    return ShareContent(
      shareUrl: shareUrl,
      shortUrl: shortUrl,
      deepLink: deepLink,
      shareText: shareText,
      platformSpecific: platformSpecific.toEntity(),
      qrCode: qrCode,
      generatedAt: DateTime.parse(generatedAt),
    );
  }
}
