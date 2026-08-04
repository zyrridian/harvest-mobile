// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlatformSpecificUrlsModel _$PlatformSpecificUrlsModelFromJson(
        Map<String, dynamic> json) =>
    PlatformSpecificUrlsModel(
      whatsapp: json['whatsapp'] as String,
      facebook: json['facebook'] as String,
      twitter: json['twitter'] as String,
      instagram: json['instagram'] as String,
    );

Map<String, dynamic> _$PlatformSpecificUrlsModelToJson(
        PlatformSpecificUrlsModel instance) =>
    <String, dynamic>{
      'whatsapp': instance.whatsapp,
      'facebook': instance.facebook,
      'twitter': instance.twitter,
      'instagram': instance.instagram,
    };

ShareContentModel _$ShareContentModelFromJson(Map<String, dynamic> json) =>
    ShareContentModel(
      shareUrl: json['share_url'] as String,
      shortUrl: json['short_url'] as String,
      deepLink: json['deep_link'] as String,
      shareText: json['share_text'] as String,
      platformSpecific: PlatformSpecificUrlsModel.fromJson(
          json['platform_specific'] as Map<String, dynamic>),
      qrCode: json['qr_code'] as String,
      generatedAt: json['generated_at'] as String,
    );

Map<String, dynamic> _$ShareContentModelToJson(ShareContentModel instance) =>
    <String, dynamic>{
      'share_url': instance.shareUrl,
      'short_url': instance.shortUrl,
      'deep_link': instance.deepLink,
      'share_text': instance.shareText,
      'platform_specific': instance.platformSpecific,
      'qr_code': instance.qrCode,
      'generated_at': instance.generatedAt,
    };
